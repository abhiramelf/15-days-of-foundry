// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {Auction} from "../src/Auction.sol";

contract AuctionTest is Test {
    Auction public auction;

    address owner;

    event Withdrawn(address indexed user, uint256 amount);
    event BidPlaced(address indexed bidder, uint256 amount);
    event AuctionFinalized(address indexed winner, uint256 amount);
    event AuctionCanceled();

    /*
     * Test setup
     * - Deploy the Auction contract from an EOA (owner) so transfers to seller succeed
     * - Give the owner some ETH so finalization transfer can be observed
     */
    function setUp() public {
        owner = address(0xBEEF);
        vm.deal(owner, 10 ether); // fund the EOA seller
        vm.prank(owner); // next call is from owner (EOA)
        auction = new Auction(1 days);
    }

    /// @notice initial state after deployment
    function testInitialState() public view {
        assertEq(auction.highestBidder(), address(0));
        assertEq(auction.highestBid(), 0);
        assertEq(auction.seller(), owner);
    }

    /// @notice constructor should revert when provided an end time in the past
    function testConstructor_RevertsIfEndTimeInPast() public {
        vm.expectRevert(Auction.EndTimeInPast.selector);
        // 0 is less than current block.timestamp in test env
        new Auction(0);
    }

    /// @notice bidding after the auction end time should revert
    function testAuctionEnded() public {
        vm.warp(auction.auctionEndTime());
        vm.expectRevert(Auction.AuctionEnded.selector);
        auction.bid{value: 1 ether}();
    }

    /// @notice single-account bid should update highestBid and highestBidder
    function testBid() public {
        auction.bid{value: 1 ether}();
        assertEq(auction.highestBidder(), address(this));
        assertEq(auction.highestBid(), 1 ether);
    }

    /// @notice ensure multiple users can outbid each other and state updates correctly
    function testBid_MultipleUserBids() public {
        address user1 = address(0x1);
        address user2 = address(0x2);

        vm.deal(user1, 2 ether);
        vm.deal(user2, 3 ether);

        vm.prank(user1);
        auction.bid{value: 2 ether}();
        assertEq(auction.highestBidder(), user1);
        assertEq(auction.highestBid(), 2 ether);

        vm.prank(user2);
        auction.bid{value: 3 ether}();
        assertEq(auction.highestBidder(), user2);
        assertEq(auction.highestBid(), 3 ether);
    }

    /// @notice lower-than-current-highest bids should revert with BidTooLow
    function testBid_RevertsIfLowBid() public {
        address user1 = address(0x1);
        address user2 = address(0x2);

        vm.deal(user1, 1 ether);
        vm.deal(user2, 0.5 ether);

        vm.prank(user1);
        auction.bid{value: 1 ether}();
        assertEq(auction.highestBidder(), user1);
        assertEq(auction.highestBid(), 1 ether);

        vm.expectRevert(Auction.BidTooLow.selector);
        vm.prank(user2);
        auction.bid{value: 0.5 ether}();
    }

    /// @notice bids should be rejected after the auction is canceled
    function testBid_RevertsIfCanceled() public {
        vm.prank(owner);
        auction.cancelAuction();

        address bidder2 = address(0x2);
        vm.deal(bidder2, 1 ether);
        vm.prank(bidder2);
        vm.expectRevert(Auction.AuctionIsCanceled.selector);
        auction.bid{value: 1 ether}();
    }

    /// @notice ensure BidPlaced event is emitted with correct values
    function testBid_EmitsBidPlaced() public {
        vm.expectEmit(true, false, false, true);
        emit BidPlaced(address(this), 1 ether);

        auction.bid{value: 1 ether}();
    }

    /// @notice self-outbidding should push the previous bid into the bids mapping
    function testSelfOutbid_IncrementsBidsMapping() public {
        // same account bids twice
        vm.deal(address(this), 3 ether);
        auction.bid{value: 1 ether}();
        auction.bid{value: 2 ether}(); // outbid self
        assertEq(auction.bids(address(this)), 1 ether);
    }

    /// @notice outbid user can withdraw their previous bid amount
    function testWithdraw() public {
        address user1 = address(0x1);
        address user2 = address(0x2);

        vm.deal(user1, 1 ether);
        vm.deal(user2, 2 ether);

        vm.prank(user1);
        auction.bid{value: 1 ether}();
        vm.prank(user2);
        auction.bid{value: 2 ether}();

        vm.expectEmit(true, true, true, true);
        emit Withdrawn(user1, 1 ether);

        vm.prank(user1);
        auction.withdraw();
    }

    /// @notice withdraw moves funds to the caller and clears the bids mapping
    function testWithdraw_TransfersFundsAndClearsMapping() public {
        address user1 = address(0x1);
        address user2 = address(0x2);
        vm.deal(user1, 2 ether);
        vm.deal(user2, 2 ether);

        vm.prank(user1);
        auction.bid{value: 1 ether}();
        vm.prank(user2);
        auction.bid{value: 2 ether}();

        uint256 before = user1.balance;
        vm.prank(user1);
        auction.withdraw();
        assertEq(auction.bids(user1), 0);
        assertEq(user1.balance, before + 1 ether);
    }

    /// @notice withdraw should revert when caller has no refundable balance
    function testWithdraw_RevertIfNoFundToWithdraw() public {
        address user1 = address(0x1);

        vm.deal(user1, 1 ether);
        vm.prank(user1);
        auction.bid{value: 1 ether}();

        vm.expectRevert(Auction.NoFundsToWithdraw.selector);
        vm.prank(user1);
        auction.withdraw();
    }

    /// @notice non-seller callers should be rejected for seller-only functions
    function testOnlySellerAccessControl() public {
        // non-seller cannot call finalize
        vm.prank(address(0x1));
        vm.expectRevert(Auction.NotAuthorized.selector);
        auction.finalizeAuction();

        // non-seller cannot call cancel
        vm.prank(address(0x2));
        vm.expectRevert(Auction.NotAuthorized.selector);
        auction.cancelAuction();
    }

    /// @notice happy-path finalize: highest bidder wins and AuctionFinalized is emitted
    function testFinalizeAuction() public {
        address user1 = address(0x1);
        address user2 = address(0x2);
        vm.deal(user1, 1 ether);
        vm.deal(user2, 2 ether);

        vm.prank(user1);
        auction.bid{value: 1 ether}();

        vm.prank(user2);
        auction.bid{value: 2 ether}();

        vm.warp(auction.auctionEndTime());

        vm.expectEmit(true, true, true, true);
        emit AuctionFinalized(user2, 2 ether);

        vm.prank(owner);
        auction.finalizeAuction();
    }

    /// @notice seller trying to finalize before auction end should revert
    function testFinalize_RevertsIfActive() public {
        vm.prank(owner);
        vm.expectRevert(Auction.AuctionActive.selector);
        auction.finalizeAuction();
    }

    /// @notice finalize after end with no bids should revert NoBids
    function testFinalize_RevertsIfNoBids() public {
        vm.warp(auction.auctionEndTime());
        vm.prank(owner);
        vm.expectRevert(Auction.NoBids.selector);
        auction.finalizeAuction();
    }

    /// @notice calling finalize twice should revert AuctionIsFinalized on the second call
    function testFinalize_RevertsIfAlreadyFinalized() public {
        address bidder = address(0x1);
        vm.deal(bidder, 1 ether);
        vm.prank(bidder);
        auction.bid{value: 1 ether}();

        vm.warp(auction.auctionEndTime());
        vm.prank(owner);
        auction.finalizeAuction();

        vm.prank(owner);
        vm.expectRevert(Auction.AuctionIsFinalized.selector);
        auction.finalizeAuction();
    }

    /// @notice finalize should transfer highest bid to the seller (EOA)
    function testFinalize_TransfersHighestBidToSeller() public {
        // ensure seller (owner) is payable EOA and receives funds
        address bidder = address(0x1);
        vm.deal(bidder, 2 ether);
        vm.prank(bidder);
        auction.bid{value: 1 ether}();

        vm.warp(auction.auctionEndTime());

        uint256 before = owner.balance;
        vm.prank(owner);
        auction.finalizeAuction();
        assertEq(owner.balance, before + 1 ether);
    }

    /// @notice seller can cancel an auction with no bids
    function testAuctionCanceled() public {
        vm.expectEmit(false, false, false, false);
        emit AuctionCanceled();

        vm.prank(owner);
        auction.cancelAuction();
    }

    /// @notice seller cannot cancel when bids are already present
    function testCancel_RevertsIfBidsAvailable() public {
        address bidder = address(0x1);
        vm.deal(bidder, 1 ether);
        vm.prank(bidder);
        auction.bid{value: 1 ether}();

        vm.prank(owner);
        vm.expectRevert(Auction.BidsAvailable.selector);
        auction.cancelAuction();
    }
}

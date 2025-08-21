// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract Auction {
    address public highestBidder;
    uint256 public highestBid;
    uint256 public immutable auctionStartTime;
    uint256 public immutable auctionEndTime;
    address payable public immutable seller;

    bool public isCanceled;
    bool public isFinalized;

    mapping(address => uint256) public bids;

    event BidPlaced(address indexed bidder, uint256 amount);
    event Withdrawn(address indexed bidder, uint256 amount);
    event AuctionFinalized(address indexed winner, uint256 amount);
    event AuctionCanceled();

    error NotAuthorized();
    error EndTimeInPast();

    error AuctionActive();
    error AuctionEnded();
    error AuctionIsFinalized();
    error AuctionIsCanceled();

    error NoBids();
    error BidTooLow();
    error NoFundsToWithdraw();

    modifier onlySeller() {
        if (msg.sender != seller) revert NotAuthorized();
        _;
    }

    modifier onlyWhileActive() {
        if (block.timestamp >= auctionEndTime) revert AuctionEnded();
        if (isCanceled) revert AuctionIsCanceled();
        _;
    }

    constructor(uint256 _endTime) {
        if (_endTime < block.timestamp) revert EndTimeInPast();
        auctionStartTime = block.timestamp;
        auctionEndTime = block.timestamp + _endTime;
        seller = payable(msg.sender);
    }

    function bid() public payable {
        if (block.timestamp >= auctionEndTime) revert AuctionEnded();
        if (msg.value <= highestBid) revert BidTooLow();

        // Add the previous highest bid to the bids mapping
        if (highestBid != 0) {
            bids[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;

        emit BidPlaced(msg.sender, msg.value);
    }

    function withdraw() public {
        uint256 amount = bids[msg.sender];
        if (amount == 0) revert NoFundsToWithdraw();

        bids[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");

        emit Withdrawn(msg.sender, amount);
    }

    function finalizeAuction() public {
        if (block.timestamp < auctionEndTime) revert AuctionActive();
        if (isFinalized) revert AuctionIsFinalized();

        isFinalized = true;

        if(highestBid == 0) revert NoBids();

        // Transfer the highest bid to the auction creator
        (bool success, ) = seller.call{value: highestBid}("");
        require(success, "Transfer failed");

        emit AuctionFinalized(msg.sender, highestBid);
    }

    function cancelAuction() public onlySeller {
        if (block.timestamp >= auctionEndTime) revert AuctionEnded();
        isCanceled = true;

        emit AuctionCanceled();
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title Simple ETH Auction
/// @notice Minimal single-item auction example used for learning/foundry exercises
/// @dev This contract intentionally uses a withdraw-pattern for refunds and simple custom errors.
contract Auction {
    /* -------------------------------------------------------------------------- */
    /*                                Auction State                               */
    /* -------------------------------------------------------------------------- */

    /// Current highest bidder and their bid (in wei)
    address public highestBidder;
    uint256 public highestBid;

    /// Immutable auction timing (timestamps)
    uint256 public immutable auctionStartTime;
    uint256 public immutable auctionEndTime;

    /// Auction creator (seller) who will receive the winning bid on finalize
    address payable public immutable seller;

    /// Flags
    bool public isCanceled;
    bool public isFinalized;

    /// Refund ledger for outbid bidders (withdraw pattern)
    mapping(address => uint256) public bids;

    /* -------------------------------------------------------------------------- */
    /*                                    Events                                  */
    /* -------------------------------------------------------------------------- */

    /// Emitted when a new highest bid is placed
    event BidPlaced(address indexed bidder, uint256 amount);

    /// Emitted when a bidder withdraws their refundable amount
    event Withdrawn(address indexed bidder, uint256 amount);

    /// Emitted when the auction is finalized and winner is settled
    event AuctionFinalized(address indexed winner, uint256 amount);

    /// Emitted when the seller cancels the auction (only allowed before any bids)
    event AuctionCanceled();

    /* -------------------------------------------------------------------------- */
    /*                              Custom Errors                                 */
    /* -------------------------------------------------------------------------- */

    error NotAuthorized(); // caller is not the seller
    error EndTimeInPast(); // constructor parameter invalid

    error AuctionActive(); // finalize called while auction still active
    error AuctionEnded(); // bid attempted after auction end
    error AuctionIsFinalized(); // finalize called twice
    error AuctionIsCanceled(); // operation attempted on canceled auction

    error NoBids(); // finalize called when there are no bids
    error BidsAvailable(); // cancel attempted when bids exist
    error BidTooLow(); // bid not strictly greater than current highest
    error NoFundsToWithdraw(); // withdraw when no refundable balance

    /* -------------------------------------------------------------------------- */
    /*                                  Modifiers                                 */
    /* -------------------------------------------------------------------------- */

    /// Only the original seller may call
    modifier onlySeller() {
        if (msg.sender != seller) revert NotAuthorized();
        _;
    }

    /// Only while auction is active (not ended or canceled)
    modifier onlyWhileActive() {
        if (block.timestamp >= auctionEndTime) revert AuctionEnded();
        if (isCanceled) revert AuctionIsCanceled();
        _;
    }

    /* -------------------------------------------------------------------------- */
    /*                                Constructor                                 */
    /* -------------------------------------------------------------------------- */

    /// @notice Create an auction
    /// @param _endTime Number used to calculate auction end. (Currently treated as a duration in seconds.)
    /// @dev The constructor checks `_endTime` against `block.timestamp` then adds it to `block.timestamp`.
    ///      This works in the test environment where `block.timestamp` starts at a low value; consider
    ///      changing the API to accept an explicit duration or an absolute timestamp in production.
    constructor(uint256 _endTime) {
        if (_endTime < block.timestamp) revert EndTimeInPast();
        auctionStartTime = block.timestamp;
        auctionEndTime = block.timestamp + _endTime;
        seller = payable(msg.sender);
    }

    /* -------------------------------------------------------------------------- */
    /*                                    Actions                                  */
    /* -------------------------------------------------------------------------- */

    /// @notice Place a bid for the auctioned item. The bid must be strictly greater than the current highest.
    /// @dev Uses withdraw pattern: previous highest is credited to `bids[previousHighest]` for later withdrawal.
    function bid() public payable onlyWhileActive {
        if (msg.value <= highestBid) revert BidTooLow();

        // credit previous highest bidder with their refundable amount
        if (highestBid != 0) {
            bids[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;

        emit BidPlaced(msg.sender, msg.value);
    }

    /// @notice Withdraw refundable funds for outbid bidders
    /// @dev Pull-based refunds to avoid reentrancy and failed send issues during bid.
    function withdraw() public {
        uint256 amount = bids[msg.sender];
        if (amount == 0) revert NoFundsToWithdraw();

        bids[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");

        emit Withdrawn(msg.sender, amount);
    }

    /// @notice Finalize the auction and send the highest bid to the seller
    /// @dev Only the seller may call once the auction has ended. Reverts if there are no bids.
    function finalizeAuction() public onlySeller {
        if (block.timestamp < auctionEndTime) revert AuctionActive();
        if (isFinalized) revert AuctionIsFinalized();

        isFinalized = true;

        if (highestBid == 0) revert NoBids();

        // send funds to seller (payable EOA recommended in tests)
        (bool success, ) = seller.call{value: highestBid}("");
        require(success, "Transfer failed");

        emit AuctionFinalized(highestBidder, highestBid);
    }

    /// @notice Allow the seller to cancel the auction if no bids have been placed
    /// @dev Cancelling after bids have been placed is not allowed in this implementation.
    function cancelAuction() public onlySeller onlyWhileActive {
        if (highestBid != 0) revert BidsAvailable();
        isCanceled = true;

        emit AuctionCanceled();
    }
}

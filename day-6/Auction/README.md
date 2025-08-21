# Auction (day-6)

This folder contains a minimal single-item ETH auction implemented for Foundry exercises.

Files of interest
- `src/Auction.sol` — the auction contract (withdraw-pattern refunds, seller finalize, cancellation)
- `test/Auction.t.sol` — comprehensive Forge tests covering errors, events and state changes

Quick summary
- The contract keeps the highest bid and highest bidder in `highestBid` / `highestBidder`.
- Outbid bidders are credited in `bids[address]` and must call `withdraw()` to reclaim funds (pull pattern).
- The seller (deployer) calls `finalizeAuction()` after the auction end to receive the highest bid.
- Seller may `cancelAuction()` before any bids have been placed.

Notable public API
- `bid()` payable — place a new strict-greater bid (reverts `BidTooLow` if not).
- `withdraw()` — withdraw refundable balance for outbid bidders (reverts `NoFundsToWithdraw` if none).
- `finalizeAuction()` — seller-only, callable after end; transfers highest bid to seller (reverts `NoBids` if none).
- `cancelAuction()` — seller-only, callable while active and only if no bids exist.

Custom errors & events
- Custom errors: `NotAuthorized`, `EndTimeInPast`, `AuctionActive`, `AuctionEnded`, `AuctionIsFinalized`,
	`AuctionIsCanceled`, `NoBids`, `BidsAvailable`, `BidTooLow`, `NoFundsToWithdraw`.
- Events: `BidPlaced`, `Withdrawn`, `AuctionFinalized`, `AuctionCanceled`.

Testing & running
All tests were written with Foundry (forge). From this folder (or repo root) run:

```bash
forge test -v
forge coverage
```

Formatting / build utilities

```bash
forge fmt
forge build
```

Testing tips / implementation notes
- The contract's constructor currently interprets the `_endTime` parameter by comparing it to `block.timestamp`
	and then storing `auctionEndTime = block.timestamp + _endTime`. In tests it's simpler to deploy using an EOA
	via `vm.prank(owner)` so `seller` is an external account that can receive ETH during `finalizeAuction()`.
- Tests use `vm.deal()` and `vm.prank(...)` when simulating bidders and the seller. If you see transfer failures
	during finalization, make sure the contract's `seller` is an EOA in tests or make the test contract payable.
- The withdraw (pull) pattern avoids reentrancy during bidding; tests assert both event emission and actual
	balance changes for withdraw/finalize flows.

Further reading
- Foundry Book: https://book.getfoundry.sh/

License
- SPDX: MIT (follow the repository license)
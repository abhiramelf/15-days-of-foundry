# 15 Days of Foundry

This repository contains a series of daily projects and exercises to learn and master smart contract development using [Foundry](https://book.getfoundry.sh/). Each day focuses on a new concept or contract, with practical examples and tests.


## Structure

- `day-1/Counter/` — Example Counter contract with tests and scripts
   - `src/Counter.sol` — The main Counter contract
   - `test/Counter.t.sol` — Foundry test for Counter
   - `script/Counter.s.sol` — Example deployment/interactions script
   - `lib/forge-std/` — Foundry standard library for testing

- `day-2/Greeting/` — Greeting contract with tests and scripts
   - `src/Greeting.sol` — The main Greeting contract
   - `test/Greeting.t.sol` — Foundry test for Greeting
   - `script/Greeting.s.sol` — Example deployment/interactions script
   - `lib/forge-std/` — Foundry standard library

- `day-3/SimpleBank/` — SimpleBank contract, factory, tests, and scripts
   - `src/SimpleBank.sol` — The main SimpleBank contract
   - `src/SimpleBankFactory.sol` — Factory contract to deploy new SimpleBank instances
   - `test/SimpleBank.t.sol` — Foundry test for SimpleBank
   - `script/SimpleBank.s.sol` — Example deployment/interactions script
   - `lib/forge-std/` — Foundry standard library

- `day-4/TokenSwap/` — TokenSwap contract, ERC20 tokens, tests, and scripts
   - `src/TokenSwap.sol` — The main TokenSwap contract
   - `src/TokenA.sol` — ERC20 TokenA implementation
   - `src/TokenB.sol` — ERC20 TokenB implementation
   - `test/TowknSwap.t.sol` — Unit, fuzz, and invariant tests for TokenSwap
   - `lib/forge-std/` — Foundry standard library

- `day-5/BatchTransfer/` — BatchTransfer contracts and tests
   - `src/GassyBatchTransfer.sol` — Gas-inefficient batch transfer contract (for learning)
   - `src/OptimizedBatchTransfer.sol` — Highly gas-optimized batch transfer contract
   - `test/BatchTransfer.t.sol` — Test suite for gas usage and edge cases
   - `test/BatchTransferSnapshot.t.sol` — Snapshot tests for batch transfers
   - `lib/forge-std/` — Foundry standard library

- `day-6/Auction/` — Simple ETH auction contract and tests
   - `src/Auction.sol` — Minimal auction contract using withdraw-pattern refunds
   - `test/Auction.t.sol` — Comprehensive tests for all error cases, events, and state changes
   - `lib/forge-std/` — Foundry standard library
   - `README.md` — Project-specific notes and usage tips

## Getting Started

1. **Install Foundry**
   - Follow instructions at [Foundry Book](https://book.getfoundry.sh/getting-started/installation.html)

2. **Install dependencies**
   - Run `forge install` in the project directory if needed

3. **Run tests**
   - Navigate to a day's folder (e.g., `day-1/Counter/`)
   - Run:
     ```bash
     forge test -vvvv
     forge coverage
     ```

## Daily Projects

### Day 1: Counter
Implements a simple counter contract with increment, decrement, and set functions. Includes unit tests and a script for deployment/interactions.

### Day 2: Greeting
Implements a contract to store and update a greeting message. Demonstrates state variables and setter/getter patterns in Solidity.

### Day 3: SimpleBank
Implements a basic bank contract for deposits, withdrawals, and balance tracking. Includes a factory contract so any wallet can deploy its own SimpleBank instance as owner.

### Day 4: TokenSwap
Implements a token swap contract for exchanging two ERC20 tokens (TokenA and TokenB) and providing liquidity. Includes fuzz and invariant tests to ensure robust behavior and security.

### Day 5: BatchTransfer
Demonstrates different approaches to batch transferring Ether to multiple recipients, including intentionally gas-inefficient and highly optimized contracts. Includes tests for gas usage and edge cases, allowing benchmarking and comparison of Solidity patterns.

### Day 6: Auction
Implements a minimal ETH auction contract with withdraw-pattern refunds, seller-only finalize, and cancellation before bids. Includes comprehensive tests for all error cases, events, and state changes. See the Auction folder's README for more details and usage tips.


## License

MIT

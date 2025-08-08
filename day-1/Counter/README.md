## Day 1: Counter

This folder contains a simple Counter smart contract and related Foundry scripts and tests.

### Structure

- `src/Counter.sol` — The main Counter contract
- `test/Counter.t.sol` — Unit tests for Counter
- `script/Counter.s.sol` — Script for deployment/interactions
- `lib/forge-std/` — Foundry standard library

### Counter Contract

Implements basic increment, decrement, and set functions for a uint256 counter. Useful for learning contract state management and testing.

### Usage

#### Build

```shell
forge build
```

#### Test

```shell
forge test
```

#### Foundry Docs

https://book.getfoundry.sh/

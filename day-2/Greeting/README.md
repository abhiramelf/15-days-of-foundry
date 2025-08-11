## Foundry
# Day 2: Greeting

This folder contains a simple Greeting smart contract and related Foundry scripts and tests.

## Structure

- `src/Greeting.sol` — The main Greeting contract
- `test/Greeting.t.sol` — Unit tests for Greeting
- `script/Greeting.s.sol` — Script for deployment/interactions
- `lib/forge-std/` — Foundry standard library

## Greeting Contract

Implements basic functionality to store and update a greeting message on-chain. Useful for learning about state variables and setter/getter patterns in Solidity.

## Usage

### Build
```bash
forge build
```

### Test
```bash
forge test
```

### Format
```bash
forge fmt
```

### Deploy (example)
```bash
forge script script/Greeting.s.sol:GreetingScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

## Foundry Docs
https://book.getfoundry.sh/
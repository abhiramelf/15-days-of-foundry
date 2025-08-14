## Foundry
# Day 4: TokenSwap

This folder contains the TokenSwap smart contract and related Foundry scripts and tests for swapping between two ERC20 tokens and providing liquidity.

## Structure

- `src/TokenSwap.sol` — The main TokenSwap contract
- `src/TokenA.sol` — ERC20 TokenA implementation
- `src/TokenB.sol` — ERC20 TokenB implementation
- `test/TowknSwap.t.sol` — Unit, fuzz, and invariant tests for TokenSwap
- `lib/forge-std/` — Foundry standard library

## TokenSwap Contract

Allows users to:
- Swap TokenA for TokenB and vice versa
- Add liquidity for TokenA and TokenB

All swaps and liquidity actions use standard ERC20 approvals and transfers. Security checks ensure users and the contract have enough balance for each action.

## Usage

### Build
```bash
forge build
```

### Test
```bash
forge test
```

### Fuzz and Invariant Testing
The test suite includes fuzz tests for swapping and liquidity, and invariant tests to ensure total supply and balance sums remain correct.

### Deploy (example)
```bash
forge create <your_contract_name> --interactive --broadcast
```

## Foundry Docs
https://book.getfoundry.sh/
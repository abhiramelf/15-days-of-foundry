
# Day 3: SimpleBank

This folder contains the SimpleBank smart contract, a factory contract for deploying multiple banks, and related Foundry scripts and tests.

## Structure

- `src/SimpleBank.sol` — The main SimpleBank contract
- `src/SimpleBankFactory.sol` — Factory contract to deploy new SimpleBank instances
- `test/SimpleBank.t.sol` — Example test (update/add more tests for SimpleBank as needed)
- `script/SimpleBank.s.sol` — Example deployment/interactions script (update/add for SimpleBank as needed)
- `lib/forge-std/` — Foundry standard library

## SimpleBank Contract

Implements basic deposit, withdraw, and balance tracking for a single user (owner). The factory contract allows any wallet to deploy its own SimpleBank instance, becoming the owner of that instance.

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
forge script script/SimpleBank.s.sol:SimpleBankScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```
Update the script and test files to target SimpleBank for deployment and testing.

### Foundry Docs
https://book.getfoundry.sh/

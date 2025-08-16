
# BatchTransfer Project

This project demonstrates different approaches to batch transferring Ether to multiple recipients, including intentionally gas-inefficient and highly optimized contracts. It is designed for learning, benchmarking, and comparing gas usage in Solidity.

## Structure

- `src/GassyBatchTransfer.sol` — A deliberately gas-inefficient contract for batch transfers (for learning and comparison)
- `src/OptimizedBatchTransfer.sol` — A highly gas-optimized contract for batch transfers
- `test/BatchTransfer.t.sol` — Test suite for gas usage and edge cases
- `test/BatchTransferSnapshot.t.sol` — Snapshot tests for batch transfers
- `lib/forge-std/` — Foundry standard library

## Contracts

- **GassyBatchTransfer:** Demonstrates anti-patterns that increase gas costs, such as repeated storage writes, dynamic arrays, and unnecessary checks.
- **OptimizedBatchTransfer:** Uses best practices for gas efficiency, including single storage updates, custom errors, calldata, and minimal checks.

## Usage

### Build
```bash
forge build
```

### Test
```bash
forge test
```

### Gas Profiling
Run the test suite and use Foundry's gas profiler to compare contracts:
```bash
forge test --gas-report
forge snapshot
```

### Format
```bash
forge fmt
```

## Documentation

https://book.getfoundry.sh/

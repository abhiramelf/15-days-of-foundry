# 15 Days of Foundry

This repository contains a series of daily projects and exercises to learn and master smart contract development using [Foundry](https://book.getfoundry.sh/). Each day focuses on a new concept or contract, with practical examples and tests.

## Structure

- `day-1/Counter/` — Example Counter contract with tests and scripts
    - `src/Counter.sol` — The main Counter contract
    - `test/Counter.t.sol` — Foundry test for Counter
    - `script/Counter.s.sol` — Example deployment/interactions script
    - `lib/forge-std/` — Foundry standard library for testing

## Getting Started

1. **Install Foundry**
   - Follow instructions at [Foundry Book](https://book.getfoundry.sh/getting-started/installation.html)

2. **Install dependencies**
   - Run `forge install` in the project directory if needed

3. **Run tests**
   - Navigate to a day's folder (e.g., `day-1/Counter/`)
   - Run:
     ```bash
     forge test
     ```

## Day 1: Counter

Implements a simple counter contract with increment, decrement, and set functions. Includes unit tests and a script for deployment/interactions.

## License

MIT

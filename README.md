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
   - `test/SimpleBank.t.sol` — Example test (update/add more tests for SimpleBank as needed)
   - `script/SimpleBank.s.sol` — Example deployment/interactions script (update/add for SimpleBank as needed)
   - `lib/forge-std/` — Foundry standard library

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


## Daily Projects

### Day 1: Counter
Implements a simple counter contract with increment, decrement, and set functions. Includes unit tests and a script for deployment/interactions.

### Day 2: Greeting
Implements a contract to store and update a greeting message. Demonstrates state variables and setter/getter patterns in Solidity.

### Day 3: SimpleBank
Implements a basic bank contract for deposits, withdrawals, and balance tracking. Includes a factory contract so any wallet can deploy its own SimpleBank instance as owner.


## License

MIT

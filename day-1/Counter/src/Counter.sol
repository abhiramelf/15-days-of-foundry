// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// This is a simple counter contract that allows you to set a number,
// increment it, and decrement it, with a check to prevent negative values.
contract Counter {
    uint256 public number; // The current value of the counter

    // Sets the initial value of the counter
    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    // Increments the counter by 1
    function increment() public {
        number++;
    }

    // Decrements the counter by 1
    function decrement() public {
        require(number > 0, "Counter cannot be negative");
        number--;
    }
}

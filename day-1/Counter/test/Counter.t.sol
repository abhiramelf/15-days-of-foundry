// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";

// This is a test contract for the Counter contract.
// It includes tests for incrementing, decrementing, and setting the counter value.
contract CounterTest is Test {
    Counter public counter; // Instance of the Counter contract

    // Sets up the test environment before each test
    function setUp() public {
        counter = new Counter();
        counter.setNumber(0);
    }

    // Tests if the counter increments correctly
    function test_Increment() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }

    // Tests if the counter decrements correctly
    function test_Decrement() public {
        counter.setNumber(1); // Set initial value to 1
        counter.decrement();
        assertEq(counter.number(), 0);
    }

    // Tests if decrementing below zero reverts with the correct error message
    function test_DecrementReverts() public {
        counter.setNumber(0); // Set initial value to 0
        vm.expectRevert("Counter cannot be negative");
        counter.decrement();
    }

    function testFuzz_SetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }
}

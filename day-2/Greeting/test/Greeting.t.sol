// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {Greeting} from "../src/Greeting.sol";

contract GreetingTest is Test {
    Greeting public greeting; // Instance of the Greeting contract

    /// @notice Sets up the test environment before each test
    function setUp() public {
        greeting = new Greeting();
        greeting.setGreeting("Hello! Welcome to testing with Foundry.");
    }

    /// @notice Tests the default greeting message
    function test_DefaultGreeting() public view {
        assertEq(greeting.defaultGreeting(), "Hello, World!");
    }

    /// @notice Tests the goGreet function
    function test_GoGreet() public view {
        assertEq(greeting.goGreet(), "Hello! Welcome to testing with Foundry.");
    }

    /// @notice Tests the setGreeting function
    function testFuzz_SetGreeting(string memory x) public {
        greeting.setGreeting(x);
        assertEq(greeting.goGreet(), x);
    }
}

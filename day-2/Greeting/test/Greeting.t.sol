// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Greeting} from "../src/Greeting.sol";

contract GreetingTest is Test {
    Greeting public greeting;

    function setUp() public {
        greeting = new Greeting();
        greeting.setGreeting("Hello, World!");
    }

    function test_GoGreet() public view {
        assertEq(greeting.goGreet(), "Hello, World!");
    }

    function testFuzz_SetGreeting(string memory x) public {
        greeting.setGreeting(x);
        assertEq(greeting.goGreet(), x);
    }
}

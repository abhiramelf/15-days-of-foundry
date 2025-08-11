// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {SimpleBankFactory, SimpleBank} from "../src/SimpleBankFactory.sol";

contract SimpleBankFactoryTest is Test {
    SimpleBankFactory public factory;

    // Set up the factory before each test
    function setUp() public {
        factory = new SimpleBankFactory();
    }

    // Test creating a new bank
    function testCreateBank() public {
        address bankAddress = factory.createBank();
        assertEq(bankAddress, address(factory.banks(0)));
    }

    // Test getting the bank count
    function testGetBankCount() public {
        factory.createBank();
        factory.createBank();
        SimpleBank[] memory banks = factory.getBanks();
        assertEq(banks.length, 2);
    }
}

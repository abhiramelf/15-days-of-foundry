// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {SimpleBank} from "../src/SimpleBank.sol";

contract SimpleBankTest is Test {
    SimpleBank public bank;

    // Set up the contract
    function setUp() public {
        bank = new SimpleBank(msg.sender);
    }

    // Test deposit by owner
    function testDepositByOwner() public {
        vm.startPrank(bank.owner());
        uint256 initialBalance = bank.getBalance();
        bank.deposit{value: 1 ether}();
        uint256 newBalance = bank.getBalance();
        assertEq(newBalance, initialBalance + 1 ether);
        vm.stopPrank();
    }

    // Test deposit by non-owner
    function testDepositByNonOwner() public {
        vm.prank(bank.owner());
        uint256 initialBalance = 0;
        bank.deposit{value: 1 ether}();
        vm.prank(bank.owner());
        uint256 newBalance = bank.getBalance();
        assertEq(newBalance, initialBalance + 1 ether);
    }

    // Test withdraw by owner
    function testWithdrawByOwner() public {
        vm.startPrank(bank.owner());
        bank.deposit{value: 1 ether}();
        uint256 initialBalance = bank.getBalance();
        bank.withdraw(0.5 ether);
        uint256 newBalance = bank.getBalance();
        assertEq(newBalance, initialBalance - 0.5 ether);
        vm.stopPrank();
    }

    // Test withdraw with insufficient balance
    function testWithdrawNoBalance() public {
        vm.startPrank(bank.owner());
        bank.deposit{value: 1 ether}();
        vm.expectRevert("Insufficient balance");
        bank.withdraw(2 ether);
        vm.stopPrank();
    }

    // Test withdraw by non-owner
    function testWithdrawByNonOwner() public {
        bank.deposit{value: 1 ether}();
        vm.expectRevert("Not the contract owner");
        bank.withdraw(0.5 ether);
    }

    // Test get balance by owner
    function testGetBalanceByOwner() public {
        vm.startPrank(bank.owner());
        bank.deposit{value: 1 ether}();
        uint256 balance = bank.getBalance();
        assertEq(balance, 1 ether);
        vm.stopPrank();
    }

    // Test get balance by non-owner
    function testGetBalanceByNonOwner() public {
        vm.expectRevert("Not the contract owner");
        bank.getBalance();
    }
}

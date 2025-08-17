// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title Batch Transfer Test
/// @notice This contract tests the gas usage of different batch transfer implementations.
/// Comment the GassyBatchTransfer references and uncomment the OptimizedBatchTransfer references
/// for getting gas reports of OptimizedBatchTransfer contract and vice versa.

import {Test, console} from "forge-std/Test.sol";
import {GassyBatchTransfer} from "../src/GassyBatchTransfer.sol";
//import {OptimizedBatchTransfer} from "../src/OptimizedBatchTransfer.sol";

contract BatchTransferTest is Test {
    GassyBatchTransfer public gassyBatchTransfer;
    //OptimizedBatchTransfer public optimizedBatchTransfer;
    address[] public recipients;
    uint256[] public amounts;
    address public owner;

    uint256 public constant NUM_RECIPIENTS = 10;
    uint256 public constant AMOUNT_PER_RECIPIENT = 10 ether;

    function setUp() public {
        gassyBatchTransfer = new GassyBatchTransfer();
        //optimizedBatchTransfer = new OptimizedBatchTransfer();
        owner = address(this);

        for (uint256 i = 0; i < NUM_RECIPIENTS; i++) {
            // Create new, unique addresses for recipients using Foundry's `makeAddr` cheatcode.
            address recipient = makeAddr(string(abi.encodePacked("recipient", vm.toString(i + 1))));
            recipients.push(recipient);
            amounts.push(AMOUNT_PER_RECIPIENT);
        }

        uint256 totalAmount = AMOUNT_PER_RECIPIENT * NUM_RECIPIENTS;
        vm.deal(address(gassyBatchTransfer), totalAmount);
        //vm.deal(address(optimizedBatchTransfer), totalAmount);

        assertEq(address(gassyBatchTransfer).balance, totalAmount, "Initial balance not correct");
        //assertEq(address(optimizedBatchTransfer).balance, totalAmount, "Initial balance not correct");
    }

    // Add your test functions here
    function test_gas_batchTransfer() public {
        // Test the gas consumption of the batch transfer function
        uint256 gasUsed = gasleft();

        gassyBatchTransfer.batchTransfer(recipients, amounts);
        gasUsed -= gasleft();
        console.log("Gas used for gassy batch transfer:", gasUsed);
        emit log_named_uint("Gas used for gassy batch transfer", gasUsed);

        // optimizedBatchTransfer.batchTransfer(recipients, amounts);
        // gasUsed -= gasleft();
        // console.log("Gas used for optimized batch transfer:", gasUsed);
        // emit log_named_uint("Gas used for optimized batch transfer", gasUsed);
    }
}
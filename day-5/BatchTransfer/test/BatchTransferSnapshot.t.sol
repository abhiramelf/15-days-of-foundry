// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title Batch Transfer Snapshot Test
/// @notice This contract save the gas snapshots of different batch transfer implementations.
/// Comment the GassyBatchTransfer references and uncomment the OptimizedBatchTransfer references
/// for getting gas snapshots of OptimizedBatchTransfer contract and vice versa.

import {Test, console} from "forge-std/Test.sol";
import {GassyBatchTransfer} from "../src/GassyBatchTransfer.sol";
//import {OptimizedBatchTransfer} from "../src/OptimizedBatchTransfer.sol";

contract BatchTransferSnapshotTest is Test {
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

        for (uint256 i = 0; i < NUM_RECIPIENTS; i++) {
            // Create new, unique addresses for recipients using Foundry's `makeAddr` cheatcode.
            address recipient = makeAddr(string(abi.encodePacked("recipient", vm.toString(i + 1))));
            recipients.push(recipient);
            amounts.push(AMOUNT_PER_RECIPIENT);
        }

        uint256 totalAmount = AMOUNT_PER_RECIPIENT * NUM_RECIPIENTS;
        vm.deal(address(gassyBatchTransfer), totalAmount);
        //vm.deal(address(optimizedBatchTransfer), totalAmount);
    }

    // Add your test functions here
    function test_snapshot_batchTransfer() public {

        // Perform the batch transfer
        gassyBatchTransfer.batchTransfer(recipients, amounts);
        //optimizedBatchTransfer.batchTransfer(recipients, amounts);
    }
}
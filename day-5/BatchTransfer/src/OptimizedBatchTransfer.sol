// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract GasSaver {

    uint256 public totalTransfersCompleted = 0;
    uint256 public totalEtherSent = 0;
    address public immutable owner;

    constructor() {
        owner = msg.sender;
    }

    // Event to log each transfer. This is an efficient way to log activity.
    event EtherTransferred(address indexed recipient, uint256 amount);

    // Custom error definitions for better error handling and gas efficiency
    error NotOwner();
    error RecipientAndAmountMismatch();
    error NoRecipients();
    error ZeroAddress();
    error InsufficientBalance();

    // Receives Ether to fund the contract for batch transfers.
    receive() external payable {}

    // Batch transfers Ether to multiple recipients in a gas-efficient way.
    function batchTransfer(address[] calldata _recipients, uint256[] calldata _amounts) onlyOwner public payable {

        if (_recipients.length != _amounts.length) revert RecipientAndAmountMismatch();
        if (_recipients.length == 0) revert NoRecipients();

        // We use a local variable to sum up the total amount to be sent.
        // Operations in memory are much cheaper than operations in storage (i.e., updating state variables).
        uint256 totalAmountToSend = 0;
        uint256 recipientsCount = _recipients.length; // Caching array length in a local variable saves gas on each loop access.

        for (uint256 i = 0; i < recipientsCount; i++) {
            // This check remains inside the loop for security, ensuring no funds are sent to an invalid address.
            if (_recipients[i] == address(0)) revert ZeroAddress();
            // Add the amount to our local sum variable.
            totalAmountToSend += _amounts[i];
        }

        if (address(this).balance < totalAmountToSend) revert InsufficientBalance();

        // We loop again to perform the actual transfers
        for (uint256 i = 0; i < recipientsCount; i++) {
            payable(_recipients[i]).transfer(_amounts[i]);
            emit EtherTransferred(_recipients[i], _amounts[i]);
        }

        // This is the most critical optimization. We update the state variables only ONCE,
        // after the loop has completed. This saves an enormous amount of gas compared to updating in every iteration.
        totalTransfersCompleted += recipientsCount;
        totalEtherSent += totalAmountToSend;
    }

    // A helper function to check the contract's current balance.
    function getBalance() onlyOwner public view returns (uint256) {
        return address(this).balance;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }
}
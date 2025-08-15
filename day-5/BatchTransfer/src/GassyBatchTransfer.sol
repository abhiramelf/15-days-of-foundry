// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract GassyBatchTransfer {

    uint256 public totalTransfersCompleted = 0;
    uint256 public totalEtherSent = 0;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    // Event to log each transfer. Events are cheaper than storage, but still add to the cost.
    event EtherTransferred(address indexed recipient, uint256 amount);

    // Receives Ether to fund the contract for batch transfers.
    receive() external payable {}

    // Batch transfers Ether to multiple recipients in a highly inefficient way.
    function batchTransfer(address[] memory _recipients, uint256[] memory _amounts) onlyOwner public payable {

        require(_recipients.length == _amounts.length, "Recipients and amounts arrays must have the same length.");
        require(_recipients.length > 0, "No recipients provided.");

        // Using a 'for' loop that iterates and performs state-changing operations consumes a lot of gas.
        for (uint256 i = 0; i < _recipients.length; i++) {

            // This check for a zero address is repeated in every iteration, hence a lot of gas is consumed.
            require(_recipients[i] != address(0), "Cannot send to the zero address.");

            // Using address.transfer() inside a loop creates an external call for each recipient.
            // Each call has a gas cost associated with it.
            payable(_recipients[i]).transfer(_amounts[i]);

            // This is the most significant source of gas inefficiency.
            // We are writing to storage in every single iteration of the loop.
            // Each update is a separate storage write operation (SSTORE), which is one of the most expensive opcodes.
            totalTransfersCompleted += 1;
            totalEtherSent += _amounts[i];

            emit EtherTransferred(_recipients[i], _amounts[i]);
        }
    }

    // A helper function to check the contract's current balance.
    function getBalance() onlyOwner public view returns (uint256) {
        return address(this).balance;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }
}
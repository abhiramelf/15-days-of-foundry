// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

// Importing Ownable to add an owner and increase storage reads.
import "@openzeppelin/contracts/access/Ownable.sol";

contract GassyBatchTransfer is Ownable {

    constructor() Ownable(msg.sender) {}

    uint256 public totalTransfersCompleted = 0;
    uint256 public totalEtherSent = 0;


    // A mapping to store data for each recipient.
    mapping(address => uint256) public recipientTransferCounts;

    // A dynamic array in storage. Pushing to this array in a loop is extremely inefficient
    address[] public transferHistory;

    event EtherTransferred(address indexed recipient, uint256 amount);

    // Receives Ether to fund the contract for batch transfers.
    receive() external payable {}

    // Batch transfers Ether to multiple recipients in a highly inefficient way.
    function batchTransfer(address[] memory _recipients, uint256[] memory _amounts) public payable onlyOwner {

        require(_recipients.length == _amounts.length, "Recipients and amounts arrays must have the same length.");
        require(_recipients.length > 0, "No recipients provided.");

        for (uint256 i = 0; i < _recipients.length; i++) {
            address recipient = _recipients[i];
            uint256 amount = _amounts[i];

            // --- Inefficient Check inside the loop ---
            require(recipient != address(0), "Cannot send to the zero address.");

            // Reading from storage (SLOAD) in a loop costs gas every time.
            // We read the owner address here even though it doesn't change and isn't used.
            address contractOwner = owner();
            require(contractOwner != address(0)); // Dummy check to prevent compiler optimization

            payable(recipient).transfer(amount);

            totalTransfersCompleted += 1;
            totalEtherSent += amount;

            // Update the mapping for the recipient.
            recipientTransferCounts[recipient] += 1;

            // Push the recipient to the storage array. This is one of the most
            // gas-intensive operations you can put in a loop.
            transferHistory.push(recipient);

            emit EtherTransferred(recipient, amount);
        }
    }

    // A helper function to check the contract's current balance.
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

// Simple bank contract that allows users to deposit, withdraw, and check their balances.
contract SimpleBank {
    address private owner; // Owner of the contract
    mapping(address => uint256) private balances; // Mapping of user addresses to their balances

    constructor(address _owner) {
        owner = _owner;
    }

    // Set owner
    function setOwner(address newOwner) onlyOwner public {
        owner = newOwner;
    }

    // Deposit Ether into the bank
    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        balances[msg.sender] += msg.value;
    }

    // Withdraw Ether from the bank, only owner can call
    function withdraw(uint256 amount) onlyOwner public {
        require(balances[owner] >= amount, "Insufficient balance");
        balances[owner] -= amount;
        payable(owner).transfer(amount);
    }

    // Get the balance of the owner
    function getBalance() onlyOwner public view returns (uint256) {
        return balances[owner];
    }

    // Modifier to restrict access to the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }
}

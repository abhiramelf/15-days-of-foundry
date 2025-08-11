// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "./SimpleBank.sol";

// Factory contract to create and manage SimpleBank instances.
contract SimpleBankFactory {
    SimpleBank[] public banks;

    // Create a new SimpleBank instance.
    function createBank() public returns (address) {
        SimpleBank newBank = new SimpleBank(msg.sender);
        banks.push(newBank);
        return address(newBank);
    }

    // Get the list of all created SimpleBank instances.
    function getBanks() public view returns (SimpleBank[] memory) {
        return banks;
    }

    function getBankCount() public view returns (uint256) {
        return banks.length;
    }
}

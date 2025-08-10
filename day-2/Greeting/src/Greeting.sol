// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract Greeting {
    string greeting; // The current greeting message

    /// @notice Returns the default greeting message.
    function defaultGreeting() public pure returns (string memory) {
        return "Hello, World!";
    }

    /// @notice Sets a new greeting message.
    /// @param _greeting The new greeting message.
    function setGreeting(string memory _greeting) public {
        greeting = _greeting;
    }

    /// @notice Returns the current greeting message.
    function goGreet() public view returns (string memory) {
        return greeting;
    }
}

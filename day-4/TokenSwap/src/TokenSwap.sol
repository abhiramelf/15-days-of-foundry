// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol"; // Importing the ERC20 interface

contract TokenSwap {
    IERC20 public tokenA; // TokenA contract instance
    IERC20 public tokenB; // TokenB contract instance

    // Constructor to set the token addresses
    constructor(address _tokenA, address _tokenB) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    // Function to swap TokenA for TokenB
    function swapAforB(uint256 amount) external {
        require(amount > 0, "Amounts must be greater than zero");
        require(tokenA.balanceOf(msg.sender) >= amount, "Insufficient TokenA balance in Wallet");
        require(tokenB.balanceOf(address(this)) >= amount, "Insufficient TokenB balance in Pool");
        tokenA.transferFrom(msg.sender, address(this), amount);
        tokenB.transfer(msg.sender, amount);
    }

    // Function to swap TokenB for TokenA
    function swapBforA(uint256 amount) external {
        require(amount > 0, "Amounts must be greater than zero");
        require(tokenB.balanceOf(msg.sender) >= amount, "Insufficient TokenB balance in Wallet");
        require(tokenA.balanceOf(address(this)) >= amount, "Insufficient TokenA balance in Pool");
        tokenB.transferFrom(msg.sender, address(this), amount);
        tokenA.transfer(msg.sender, amount);
    }

    // Function to add liquidity for TokenA
    function addTokenALiquidity(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        require(tokenA.balanceOf(msg.sender) >= amount, "Insufficient TokenA balance");
        tokenA.transferFrom(msg.sender, address(this), amount);
    }

    // Function to add liquidity for TokenB
    function addTokenBLiquidity(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        require(tokenB.balanceOf(msg.sender) >= amount, "Insufficient TokenB balance");
        tokenB.transferFrom(msg.sender, address(this), amount);
    }

}

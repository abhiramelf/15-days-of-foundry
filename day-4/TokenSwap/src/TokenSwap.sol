// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenSwap {
    IERC20 public tokenA;
    IERC20 public tokenB;

    constructor(address _tokenA, address _tokenB) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    function swapAforB(uint256 amount) external {
        require(amount > 0, "Amounts must be greater than zero");
        require(tokenA.balanceOf(msg.sender) >= amount, "Insufficient TokenA balance in Wallet");
        require(tokenB.balanceOf(address(this)) >= amount, "Insufficient TokenB balance in Pool");
        tokenA.transferFrom(msg.sender, address(this), amount);
        tokenB.transfer(msg.sender, amount);
    }

    function swapBforA(uint256 amount) external {
        require(amount > 0, "Amounts must be greater than zero");
        require(tokenB.balanceOf(msg.sender) >= amount, "Insufficient TokenB balance in Wallet");
        require(tokenA.balanceOf(address(this)) >= amount, "Insufficient TokenA balance in Pool");
        tokenB.transferFrom(msg.sender, address(this), amount);
        tokenA.transfer(msg.sender, amount);
    }

    function addTokenALiquidity(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        require(tokenA.balanceOf(msg.sender) >= amount, "Insufficient TokenA balance");
        tokenA.transferFrom(msg.sender, address(this), amount);
    }

    function addTokenBLiquidity(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        require(tokenB.balanceOf(msg.sender) >= amount, "Insufficient TokenB balance");
        tokenB.transferFrom(msg.sender, address(this), amount);
    }

}

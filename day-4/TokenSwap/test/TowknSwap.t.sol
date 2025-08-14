// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Test.sol";

import "../src/TokenSwap.sol";
import "../src/TokenA.sol";
import "../src/TokenB.sol";

contract TokenSwapTest is Test {
    TokenA tokenA;
    TokenB tokenB;
    TokenSwap tokenSwap;

    address user = address(0xABCD);

    function setUp() public {
        tokenA = new TokenA();
        tokenB = new TokenB();
        tokenSwap = new TokenSwap(address(tokenA), address(tokenB));

        // Mint tokens to user and contract for liquidity
        tokenA.transfer(user, 1000e18);
        tokenB.transfer(user, 1000e18);
        tokenB.transfer(address(tokenSwap), 1000e18);
        tokenA.transfer(address(tokenSwap), 1000e18);

        vm.startPrank(user);
        tokenA.approve(address(tokenSwap), 1000e18);
        tokenB.approve(address(tokenSwap), 1000e18);
        vm.stopPrank();
    }

    // Fuzz test for addTokenALiquidity
    function testFuzz_addTokenALiquidity(uint256 amount) public {
        amount = bound(amount, 1, 1000e18);
        vm.startPrank(user);
        tokenA.approve(address(tokenSwap), amount);
        tokenSwap.addTokenALiquidity(amount);
        assertEq(tokenA.balanceOf(address(tokenSwap)), 1000e18 + amount);
        assertEq(tokenA.balanceOf(user), 1000e18 - amount);
        vm.stopPrank();
    }

    // Fuzz test for addTokenBLiquidity
    function testFuzz_addTokenBLiquidity(uint256 amount) public {
        amount = bound(amount, 1, 1000e18);
        vm.startPrank(user);
        tokenB.approve(address(tokenSwap), amount);
        tokenSwap.addTokenBLiquidity(amount);
        assertEq(tokenB.balanceOf(address(tokenSwap)), 1000e18 + amount);
        assertEq(tokenB.balanceOf(user), 1000e18 - amount);
        vm.stopPrank();
    }

    // Fuzz test for swapAforB
    function testFuzz_swapAforB(uint256 amount) public {
        amount = bound(amount, 1, 1000e18);
        vm.assume(tokenA.balanceOf(user) >= amount);
        vm.assume(tokenB.balanceOf(address(tokenSwap)) >= amount);

        vm.startPrank(user);
        tokenA.approve(address(tokenSwap), amount);
        uint256 userTokenBBefore = tokenB.balanceOf(user);
        uint256 contractTokenBBefore = tokenB.balanceOf(address(tokenSwap));
        tokenSwap.swapAforB(amount);
        assertEq(tokenA.balanceOf(user), 1000e18 - amount);
        assertEq(tokenB.balanceOf(user), userTokenBBefore + amount);
        assertEq(tokenB.balanceOf(address(tokenSwap)), contractTokenBBefore - amount);
        vm.stopPrank();
    }

    // Fuzz test for swapBforA
    function testFuzz_swapBforA(uint256 amount) public {
        amount = bound(amount, 1, 1000e18);
        vm.assume(tokenB.balanceOf(user) >= amount);
        vm.assume(tokenA.balanceOf(address(tokenSwap)) >= amount);

        vm.startPrank(user);
        tokenB.approve(address(tokenSwap), amount);
        uint256 userTokenABefore = tokenA.balanceOf(user);
        uint256 contractTokenABefore = tokenA.balanceOf(address(tokenSwap));
        tokenSwap.swapBforA(amount);
        assertEq(tokenB.balanceOf(user), 1000e18 - amount);
        assertEq(tokenA.balanceOf(user), userTokenABefore + amount);
        assertEq(tokenA.balanceOf(address(tokenSwap)), contractTokenABefore - amount);
        vm.stopPrank();
    }

    // Invariant: total supply of TokenA and TokenB never changes
    function invariant_totalSupplyConstant() public view {
        assertEq(tokenA.totalSupply(), 10000e18);
        assertEq(tokenB.totalSupply(), 10000e18);
    }

    // Invariant: sum of TokenA balances between user and contract is always <= 10000e18
    function invariant_tokenABalanceSum() public view {
        uint256 sum = tokenA.balanceOf(user) + tokenA.balanceOf(address(tokenSwap));
        assertLe(sum, 10000e18);
    }

    // Invariant: sum of TokenB balances between user and contract is always <= 10000e18
    function invariant_tokenBBalanceSum() public view {
        uint256 sum = tokenB.balanceOf(user) + tokenB.balanceOf(address(tokenSwap));
        assertLe(sum, 10000e18);
    }
}
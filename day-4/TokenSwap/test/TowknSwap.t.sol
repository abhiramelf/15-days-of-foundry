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

    address user = address(0xABCD); // User address

    /// @dev This function is called before each test
    /// @notice This function sets up the token contracts and initial balances
    function setUp() public {
        tokenA = new TokenA();
        tokenB = new TokenB();
        tokenSwap = new TokenSwap(address(tokenA), address(tokenB));

        // Mint tokens to user and contract for liquidity
        tokenA.transfer(user, 1000e18);
        tokenB.transfer(user, 1000e18);
        tokenB.transfer(address(tokenSwap), 1000e18);
        tokenA.transfer(address(tokenSwap), 1000e18);

        // Approve the TokenSwap contract to spend user tokens
        vm.startPrank(user);
        tokenA.approve(address(tokenSwap), 1000e18);
        tokenB.approve(address(tokenSwap), 1000e18);
        vm.stopPrank();
    }

    /// @dev Fuzz test for addTokenALiquidity
    /// @notice This function tests the addTokenALiquidity function with various input amounts
    function testFuzz_addTokenALiquidity(uint256 amount) public {
        amount = bound(amount, 1, 1000e18); // Bound the amount to a valid range

        // Start test for addTokenALiquidity
        vm.startPrank(user);
        tokenA.approve(address(tokenSwap), amount);
        tokenSwap.addTokenALiquidity(amount);
        // Check liquidity added
        assertEq(tokenA.balanceOf(address(tokenSwap)), 1000e18 + amount);
        assertEq(tokenA.balanceOf(user), 1000e18 - amount);
        vm.stopPrank();
    }

    /// @dev Fuzz test for addTokenBLiquidity
    /// @notice This function tests the addTokenBLiquidity function with various input amounts
    function testFuzz_addTokenBLiquidity(uint256 amount) public {
        amount = bound(amount, 1, 1000e18);

        // Start test for addTokenBLiquidity
        vm.startPrank(user);
        tokenB.approve(address(tokenSwap), amount);
        tokenSwap.addTokenBLiquidity(amount);
        // Check liquidity added
        assertEq(tokenB.balanceOf(address(tokenSwap)), 1000e18 + amount);
        assertEq(tokenB.balanceOf(user), 1000e18 - amount);
        vm.stopPrank();
    }

    /// @dev Fuzz test for swapAforB
    /// @notice This function tests the swapAforB function with various input amounts
    function testFuzz_swapAforB(uint256 amount) public {
        amount = bound(amount, 1, 1000e18);
        vm.assume(tokenA.balanceOf(user) >= amount); // User must have enough TokenA
        vm.assume(tokenB.balanceOf(address(tokenSwap)) >= amount); // TokenSwap must have enough TokenB

        // Start test for swapAforB
        vm.startPrank(user);
        tokenA.approve(address(tokenSwap), amount);
        uint256 userTokenBBefore = tokenB.balanceOf(user);
        uint256 contractTokenBBefore = tokenB.balanceOf(address(tokenSwap));
        tokenSwap.swapAforB(amount);
        // Check balances after swap
        assertEq(tokenA.balanceOf(user), 1000e18 - amount);
        assertEq(tokenB.balanceOf(user), userTokenBBefore + amount);
        assertEq(tokenB.balanceOf(address(tokenSwap)), contractTokenBBefore - amount);
        vm.stopPrank();
    }

    /// @dev Fuzz test for swapBforA
    /// @notice This function tests the swapBforA function with various input amounts
    function testFuzz_swapBforA(uint256 amount) public {
        amount = bound(amount, 1, 1000e18);
        vm.assume(tokenB.balanceOf(user) >= amount);
        vm.assume(tokenA.balanceOf(address(tokenSwap)) >= amount);

        // Start test for swapBforA
        vm.startPrank(user);
        tokenB.approve(address(tokenSwap), amount);
        uint256 userTokenABefore = tokenA.balanceOf(user);
        uint256 contractTokenABefore = tokenA.balanceOf(address(tokenSwap));
        tokenSwap.swapBforA(amount);
        // Check balances after swap
        assertEq(tokenB.balanceOf(user), 1000e18 - amount);
        assertEq(tokenA.balanceOf(user), userTokenABefore + amount);
        assertEq(tokenA.balanceOf(address(tokenSwap)), contractTokenABefore - amount);
        vm.stopPrank();
    }

    // Invariant: total supply of TokenA and TokenB never changes
    /// @notice This function checks that the total supply of both tokens remains constant
    function invariant_totalSupplyConstant() public view {
        assertEq(tokenA.totalSupply(), 10000e18);
        assertEq(tokenB.totalSupply(), 10000e18);
    }

    // Invariant: sum of TokenA balances between user and contract is always <= 10000e18
    /// @notice This function checks that the sum of TokenA balances between user and contract is always <= 10000e18
    function invariant_tokenABalanceSum() public view {
        uint256 sum = tokenA.balanceOf(user) + tokenA.balanceOf(address(tokenSwap));
        assertLe(sum, 10000e18);
    }

    // Invariant: sum of TokenB balances between user and contract is always <= 10000e18
    /// @notice This function checks that the sum of TokenB balances between user and contract is always <= 10000e18
    function invariant_tokenBBalanceSum() public view {
        uint256 sum = tokenB.balanceOf(user) + tokenB.balanceOf(address(tokenSwap));
        assertLe(sum, 10000e18);
    }
}
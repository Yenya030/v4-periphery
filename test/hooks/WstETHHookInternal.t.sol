// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {MockERC20} from "solmate/src/test/utils/mocks/MockERC20.sol";
import {FixedPointMathLib} from "solmate/src/utils/FixedPointMathLib.sol";

import {MockWstETH} from "../mocks/MockWstETH.sol";
import {WstETHHookHarness} from "../mocks/WstETHHookHarness.sol";

contract WstETHHookInternalTest is Test {
    MockWstETH wstETH;
    MockERC20 stETH;
    WstETHHookHarness hook;

    function setUp() public {
        stETH = new MockERC20("Liquid staked Ether", "stETH", 18);
        wstETH = new MockWstETH(address(stETH));
        hook = new WstETHHookHarness(wstETH);
    }

    function test_getWrapInputRequired() public view {
        uint256 amount = 1 ether;
        uint256 expected = FixedPointMathLib.divWadUp(amount, wstETH.tokensPerStEth());
        assertEq(hook.wrapRequired(amount), expected);
    }

    function test_getUnwrapInputRequired() public view {
        uint256 amount = 2 ether;
        uint256 expected = wstETH.getWstETHByStETH(amount);
        assertEq(hook.unwrapRequired(amount), expected);
    }
}

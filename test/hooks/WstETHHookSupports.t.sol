// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {Deployers} from "@uniswap/v4-core/test/utils/Deployers.sol";
import {WstETHHookHarness} from "../harness/WstETHHookHarness.sol";
import {MockWstETH} from "../mocks/MockWstETH.sol";
import {MockERC20} from "solmate/src/test/utils/mocks/MockERC20.sol";

contract WstETHHookSupportsTest is Test, Deployers {
    WstETHHookHarness public hook;
    MockWstETH public wstETH;
    MockERC20 public stETH;

    function setUp() public {
        deployFreshManagerAndRouters();
        stETH = new MockERC20("stETH", "STETH", 18);
        wstETH = new MockWstETH(address(stETH));
        hook = new WstETHHookHarness(manager, wstETH);
    }

    function test_support_flags() public {
        assertTrue(hook.supportsExactInput());
        assertFalse(hook.supportsExactOutput());
    }
}

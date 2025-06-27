// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {Deployers} from "@uniswap/v4-core/test/utils/Deployers.sol";
import {WETHHookHarness} from "../harness/WETHHookHarness.sol";
import {WETH} from "solmate/src/tokens/WETH.sol";

contract WETHHookSupportsTest is Test, Deployers {
    WETHHookHarness public hook;
    WETH public weth;

    function setUp() public {
        deployFreshManagerAndRouters();
        weth = new WETH();
        hook = new WETHHookHarness(manager, weth);
    }

    function test_support_flags() public {
        assertTrue(hook.supportsExactInput());
        assertTrue(hook.supportsExactOutput());
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {Deployers} from "@uniswap/v4-core/test/utils/Deployers.sol";
import {IHooks} from "@uniswap/v4-core/src/interfaces/IHooks.sol";
import {Hooks} from "@uniswap/v4-core/src/libraries/Hooks.sol";
import {WstETHHookHarness} from "../harness/WstETHHookHarness.sol";
import {MockWstETH} from "../mocks/MockWstETH.sol";
import {MockERC20} from "solmate/src/test/utils/mocks/MockERC20.sol";

contract WstETHHookInternalTest is Test, Deployers {
    WstETHHookHarness public hook;
    MockWstETH public wstETH;
    MockERC20 public stETH;

    function setUp() public {
        deployFreshManagerAndRouters();
        stETH = new MockERC20("stETH", "STETH", 18);
        wstETH = new MockWstETH(address(stETH));
        hook = WstETHHookHarness(
            payable(
                address(
                    uint160(
                        type(uint160).max & clearAllHookPermissionsMask | Hooks.BEFORE_SWAP_FLAG
                            | Hooks.BEFORE_ADD_LIQUIDITY_FLAG | Hooks.BEFORE_SWAP_RETURNS_DELTA_FLAG
                            | Hooks.BEFORE_INITIALIZE_FLAG
                    )
                )
            )
        );
        deployCodeTo("WstETHHookHarness", abi.encode(manager, wstETH), address(hook));
    }

    function test_wrapZeroForOne_orientation() public {
        bool expected = address(stETH) < address(wstETH);
        assertEq(hook.wrapZeroForOne(), expected);
    }

    function test_internal_rate_calculations() public {
        uint256 unwrapTarget = 1 ether;
        uint256 requiredWst = hook.getUnwrapInputRequired(unwrapTarget);
        assertEq(requiredWst, wstETH.getWstETHByStETH(unwrapTarget));

        uint256 wrapTarget = 2 ether;
        uint256 tokensPerStEth = wstETH.tokensPerStEth();
        uint256 expectedSt = (wrapTarget * 1e18 + tokensPerStEth - 1) / tokensPerStEth;
        uint256 requiredSt = hook.getWrapInputRequired(wrapTarget);
        assertEq(requiredSt, expectedSt);
    }
}

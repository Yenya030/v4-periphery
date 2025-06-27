// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {Deployers} from "@uniswap/v4-core/test/utils/Deployers.sol";
import {Hooks} from "@uniswap/v4-core/src/libraries/Hooks.sol";
import {IHooks} from "@uniswap/v4-core/src/interfaces/IHooks.sol";
import {WETHHook} from "../../src/hooks/WETHHook.sol";
import {WETH} from "solmate/src/tokens/WETH.sol";

/// @notice Tests the fallback receive function on WETHHook
contract WETHHookReceiveTest is Test, Deployers {
    WETHHook public hook;
    WETH public weth;

    function setUp() public {
        deployFreshManagerAndRouters();
        weth = new WETH();
        hook = WETHHook(
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
        deployCodeTo("WETHHook", abi.encode(manager, weth), address(hook));
    }

    /// @dev Ensure the hook can receive ETH without reverting
    function test_receive_eth() public {
        uint256 beforeBalance = address(hook).balance;
        (bool ok,) = address(hook).call{value: 1 ether}("");
        assertTrue(ok);
        assertEq(address(hook).balance, beforeBalance + 1 ether);
    }
}

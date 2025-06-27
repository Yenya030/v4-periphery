// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {PositiveDeltaHook} from "./mocks/PositiveDeltaHook.sol";
import {PoolKey} from "@uniswap/v4-core/src/types/PoolKey.sol";
import {Currency} from "@uniswap/v4-core/src/types/Currency.sol";
import {BalanceDelta} from "@uniswap/v4-core/src/types/BalanceDelta.sol";
import {IHooks} from "@uniswap/v4-core/src/interfaces/IHooks.sol";
import {ModifyLiquidityParams} from "@uniswap/v4-core/src/types/PoolOperation.sol";

contract PositiveDeltaHookTest is Test {
    PositiveDeltaHook hook;

    function setUp() public {
        hook = new PositiveDeltaHook();
    }

    function test_afterAddLiquidity_returns_delta() public {
        hook.setDelta(5);
        ModifyLiquidityParams memory params = ModifyLiquidityParams(0, 0, 0, 0);
        (bytes4 selector, BalanceDelta delta) = hook.afterAddLiquidity(
            address(this),
            PoolKey({
                currency0: Currency.wrap(address(0x1)),
                currency1: Currency.wrap(address(0x2)),
                fee: 3000,
                tickSpacing: 60,
                hooks: IHooks(address(0))
            }),
            params,
            BalanceDelta.wrap(0),
            BalanceDelta.wrap(0),
            ""
        );
        assertEq(selector, PositiveDeltaHook.afterAddLiquidity.selector);
        assertEq(BalanceDelta.unwrap(delta), int256(5) << 128);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {BaseHook} from "../src/utils/BaseHook.sol";
import {ImmutableState} from "../src/base/ImmutableState.sol";
import {IPoolManager} from "@uniswap/v4-core/src/interfaces/IPoolManager.sol";
import {IHooks} from "@uniswap/v4-core/src/interfaces/IHooks.sol";
import {Hooks} from "@uniswap/v4-core/src/libraries/Hooks.sol";
import {PoolKey} from "@uniswap/v4-core/src/types/PoolKey.sol";
import {Currency} from "@uniswap/v4-core/src/types/Currency.sol";
import {ModifyLiquidityParams, SwapParams} from "@uniswap/v4-core/src/types/PoolOperation.sol";
import {BalanceDelta, BalanceDeltaLibrary} from "@uniswap/v4-core/src/types/BalanceDelta.sol";
import {BeforeSwapDelta} from "@uniswap/v4-core/src/types/BeforeSwapDelta.sol";

contract DummyPoolManager {}

contract DummyHook is BaseHook {
    constructor(IPoolManager manager) BaseHook(manager) {}

    function validateHookAddress(BaseHook) internal pure override {}

    function getHookPermissions() public pure override returns (Hooks.Permissions memory perm) {
        perm = Hooks.Permissions({
            beforeInitialize: false,
            afterInitialize: false,
            beforeAddLiquidity: false,
            afterAddLiquidity: false,
            beforeRemoveLiquidity: false,
            afterRemoveLiquidity: false,
            beforeSwap: false,
            afterSwap: false,
            beforeDonate: false,
            afterDonate: false,
            beforeSwapReturnDelta: false,
            afterSwapReturnDelta: false,
            afterAddLiquidityReturnDelta: false,
            afterRemoveLiquidityReturnDelta: false
        });
    }
}

contract BaseHookTest is Test {
    DummyPoolManager manager;
    DummyHook hook;
    PoolKey key;
    ModifyLiquidityParams modifyParams;
    SwapParams swapParams;

    function setUp() public {
        manager = new DummyPoolManager();
        hook = new DummyHook(IPoolManager(address(manager)));

        key = PoolKey({
            currency0: Currency.wrap(address(0)),
            currency1: Currency.wrap(address(1)),
            fee: 3000,
            tickSpacing: 1,
            hooks: IHooks(address(0))
        });

        modifyParams = ModifyLiquidityParams({tickLower: -10, tickUpper: 10, liquidityDelta: 1, salt: bytes32(0)});
        swapParams = SwapParams({zeroForOne: true, amountSpecified: 1, sqrtPriceLimitX96: 0});
    }

    function test_onlyPoolManager() public {
        vm.expectRevert(ImmutableState.NotPoolManager.selector);
        hook.beforeInitialize(address(this), key, 0);
    }

    function test_allHooksRevert() public {
        vm.startPrank(address(manager));
        vm.expectRevert(BaseHook.HookNotImplemented.selector);
        hook.beforeInitialize(address(this), key, 0);

        vm.expectRevert(BaseHook.HookNotImplemented.selector);
        hook.afterInitialize(address(this), key, 0, 0);

        vm.expectRevert(BaseHook.HookNotImplemented.selector);
        hook.beforeAddLiquidity(address(this), key, modifyParams, "");

        vm.expectRevert(BaseHook.HookNotImplemented.selector);
        hook.beforeRemoveLiquidity(address(this), key, modifyParams, "");

        vm.expectRevert(BaseHook.HookNotImplemented.selector);
        hook.afterAddLiquidity(address(this), key, modifyParams, BalanceDeltaLibrary.ZERO_DELTA, BalanceDeltaLibrary.ZERO_DELTA, "");

        vm.expectRevert(BaseHook.HookNotImplemented.selector);
        hook.afterRemoveLiquidity(address(this), key, modifyParams, BalanceDeltaLibrary.ZERO_DELTA, BalanceDeltaLibrary.ZERO_DELTA, "");

        vm.expectRevert(BaseHook.HookNotImplemented.selector);
        hook.beforeSwap(address(this), key, swapParams, "");

        vm.expectRevert(BaseHook.HookNotImplemented.selector);
        hook.afterSwap(address(this), key, swapParams, BalanceDeltaLibrary.ZERO_DELTA, "");

        vm.expectRevert(BaseHook.HookNotImplemented.selector);
        hook.beforeDonate(address(this), key, 0, 0, "");

        vm.expectRevert(BaseHook.HookNotImplemented.selector);
        hook.afterDonate(address(this), key, 0, 0, "");
        vm.stopPrank();
    }
}


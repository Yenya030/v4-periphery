// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";

import {PoolKey} from "@uniswap/v4-core/src/types/PoolKey.sol";
import {Currency} from "@uniswap/v4-core/src/types/Currency.sol";
import {IHooks} from "@uniswap/v4-core/src/interfaces/IHooks.sol";
import {IPoolManager} from "@uniswap/v4-core/src/interfaces/IPoolManager.sol";

import {PoolInitializer_v4} from "../src/base/PoolInitializer_v4.sol";
import {ImmutableState} from "../src/base/ImmutableState.sol";

contract MockPoolManagerInit {
    int24 public returnedTick;
    bool public shouldRevert;
    uint160 public lastPrice;

    constructor(int24 _tick, bool _shouldRevert) {
        returnedTick = _tick;
        shouldRevert = _shouldRevert;
    }

    function initialize(PoolKey memory, uint160 sqrtPriceX96) external returns (int24) {
        lastPrice = sqrtPriceX96;
        if (shouldRevert) revert("init fail");
        return returnedTick;
    }
}

contract PoolInitializerHarness is PoolInitializer_v4 {
    constructor(IPoolManager _pm) ImmutableState(_pm) {}
}

contract PoolInitializerTest is Test {
    PoolInitializerHarness harness;
    MockPoolManagerInit manager;
    PoolKey key;

    function setUp() public {
        manager = new MockPoolManagerInit(5, false);
        harness = new PoolInitializerHarness(IPoolManager(address(manager)));
        key = PoolKey({currency0: Currency.wrap(address(1)), currency1: Currency.wrap(address(2)), fee: 0, tickSpacing: 1, hooks: IHooks(address(0))});
    }

    function test_initialize_returns_tick() public {
        int24 tick = harness.initializePool(key, 123);
        assertEq(tick, 5);
        assertEq(manager.lastPrice(), 123);
    }

    function test_initialize_returns_max_on_revert() public {
        MockPoolManagerInit bad = new MockPoolManagerInit(0, true);
        PoolInitializerHarness h2 = new PoolInitializerHarness(IPoolManager(address(bad)));
        int24 tick = h2.initializePool(key, 99);
        assertEq(tick, type(int24).max);
    }
}

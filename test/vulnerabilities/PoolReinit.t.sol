// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";

import {PoolKey} from "@uniswap/v4-core/src/types/PoolKey.sol";
import {Currency} from "@uniswap/v4-core/src/types/Currency.sol";
import {IHooks} from "@uniswap/v4-core/src/interfaces/IHooks.sol";
import {IPoolManager} from "@uniswap/v4-core/src/interfaces/IPoolManager.sol";

import {PoolInitializer_v4} from "../../src/base/PoolInitializer_v4.sol";
import {ImmutableState} from "../../src/base/ImmutableState.sol";

contract MockPoolManagerReinit {
    bool public initialized;
    uint160 public lastPrice;

    function initialize(PoolKey memory, uint160 sqrtPriceX96) external returns (int24) {
        if (initialized) revert("already init");
        initialized = true;
        lastPrice = sqrtPriceX96;
        return 5;
    }
}

contract PoolInitializerHarness is PoolInitializer_v4 {
    constructor(IPoolManager _pm) ImmutableState(_pm) {}
}

contract PoolReinitTest is Test {
    PoolInitializerHarness harness;
    MockPoolManagerReinit manager;
    PoolKey key;

    function setUp() public {
        manager = new MockPoolManagerReinit();
        harness = new PoolInitializerHarness(IPoolManager(address(manager)));
        key = PoolKey({
            currency0: Currency.wrap(address(1)),
            currency1: Currency.wrap(address(2)),
            fee: 0,
            tickSpacing: 1,
            hooks: IHooks(address(0))
        });
    }

    function test_reinitialize_returns_sentinel() public {
        int24 first = harness.initializePool(key, 123);
        assertEq(first, 5);

        int24 second = harness.initializePool(key, 456);
        assertEq(second, type(int24).max);
    }
}

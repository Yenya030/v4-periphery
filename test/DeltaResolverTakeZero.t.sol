// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {DeltaResolver} from "../src/base/DeltaResolver.sol";
import {ImmutableState} from "../src/base/ImmutableState.sol";
import {Currency} from "@uniswap/v4-core/src/types/Currency.sol";
import {IPoolManager} from "@uniswap/v4-core/src/interfaces/IPoolManager.sol";

contract MockPoolManagerTakeZero {
    uint256 public takeCallCount;

    function currencyDelta(address, Currency) external view returns (int256) {
        return 0;
    }

    function exttload(bytes32) external view returns (bytes32) {
        return bytes32(0);
    }

    function sync(Currency) external {}
    function settle() external payable {}

    function take(Currency, address, uint256) external {
        takeCallCount++;
    }
}

contract TakeZeroResolverHarness is DeltaResolver {
    constructor(MockPoolManagerTakeZero manager) ImmutableState(IPoolManager(address(manager))) {}

    function expose_take(Currency currency, address recipient, uint256 amount) external {
        _take(currency, recipient, amount);
    }

    function _pay(Currency, address, uint256) internal override {}
}

contract DeltaResolverTakeZeroTest is Test {
    MockPoolManagerTakeZero manager;
    TakeZeroResolverHarness resolver;
    Currency token;

    function setUp() public {
        manager = new MockPoolManagerTakeZero();
        resolver = new TakeZeroResolverHarness(manager);
        token = Currency.wrap(address(0x1234));
    }

    function test_take_zero_no_call() public {
        resolver.expose_take(token, address(0x1), 0);
        assertEq(manager.takeCallCount(), 0);
    }

    function test_take_nonzero_calls_poolManager() public {
        resolver.expose_take(token, address(0x1), 5);
        assertEq(manager.takeCallCount(), 1);
    }
}

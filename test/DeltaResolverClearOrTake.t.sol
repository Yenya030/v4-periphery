// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {MockERC20} from "solmate/src/test/utils/mocks/MockERC20.sol";
import {Currency} from "@uniswap/v4-core/src/types/Currency.sol";
import {IPoolManager} from "@uniswap/v4-core/src/interfaces/IPoolManager.sol";
import {DeltaResolver} from "../src/base/DeltaResolver.sol";
import {ImmutableState} from "../src/base/ImmutableState.sol";
import {ActionConstants} from "../src/libraries/ActionConstants.sol";
import {MockPoolManagerClearOrTake} from "./mocks/MockPoolManagerClearOrTake.sol";

contract ClearOrTakeHarness is DeltaResolver {
    constructor(MockPoolManagerClearOrTake manager) ImmutableState(IPoolManager(address(manager))) {}

    function expose_clearOrTake(Currency currency, uint256 amountMax) external {
        _clearOrTake(currency, amountMax);
    }

    // copied from PositionManager
    function _clearOrTake(Currency currency, uint256 amountMax) internal {
        uint256 delta = _getFullCredit(currency);
        if (delta == 0) return;
        if (delta <= amountMax) {
            poolManager.clear(currency, delta);
        } else {
            _take(currency, msgSender(), delta);
        }
    }

    // simple msgSender for testing
    function msgSender() public view returns (address) {
        return address(this);
    }

    function _pay(Currency, address, uint256) internal override {}
}

contract DeltaResolverClearOrTakeTest is Test {
    MockPoolManagerClearOrTake manager;
    ClearOrTakeHarness harness;
    MockERC20 token;
    Currency tokenCurrency;

    function setUp() public {
        manager = new MockPoolManagerClearOrTake();
        harness = new ClearOrTakeHarness(manager);
        token = new MockERC20("T", "T", 18);
        tokenCurrency = Currency.wrap(address(token));
    }

    function test_zeroDelta_noCalls() public {
        manager.setDelta(address(harness), tokenCurrency, 0);
        harness.expose_clearOrTake(tokenCurrency, 10);
        assertFalse(manager.clearCalled());
        assertFalse(manager.takeCalled());
    }

    function test_deltaCleared_whenBelowMax() public {
        manager.setDelta(address(harness), tokenCurrency, 5);
        harness.expose_clearOrTake(tokenCurrency, 10);
        assertTrue(manager.clearCalled());
        assertEq(Currency.unwrap(manager.lastClearCurrency()), Currency.unwrap(tokenCurrency));
        assertEq(manager.lastClearAmount(), 5);
        assertFalse(manager.takeCalled());
    }

    function test_deltaTaken_whenAboveMax() public {
        manager.setDelta(address(harness), tokenCurrency, 15);
        harness.expose_clearOrTake(tokenCurrency, 10);
        assertTrue(manager.takeCalled());
        assertEq(Currency.unwrap(manager.lastTakeCurrency()), Currency.unwrap(tokenCurrency));
        assertEq(manager.lastTakeRecipient(), address(harness));
        assertEq(manager.lastTakeAmount(), 15);
        assertFalse(manager.clearCalled());
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {MockERC20} from "solmate/src/test/utils/mocks/MockERC20.sol";
import {Currency} from "@uniswap/v4-core/src/types/Currency.sol";
import {DeltaResolver} from "../src/base/DeltaResolver.sol";
import {ImmutableState} from "../src/base/ImmutableState.sol";
import {IPoolManager} from "@uniswap/v4-core/src/interfaces/IPoolManager.sol";
import {ActionConstants} from "../src/libraries/ActionConstants.sol";

contract MockPoolManagerDR {
    mapping(bytes32 => int256) public deltas;

    function setDelta(address owner, Currency currency, int256 delta) external {
        deltas[keccak256(abi.encode(owner, Currency.unwrap(currency)))] = delta;
    }

    function currencyDelta(address owner, Currency currency) external view returns (int256) {
        return deltas[keccak256(abi.encode(owner, Currency.unwrap(currency)))];
    }

    function exttload(bytes32 slot) external view returns (bytes32 value) {
        return bytes32(uint256(int256(deltas[slot])));
    }

    function sync(Currency) external {}
    function settle() external payable {}
    function take(Currency, address, uint256) external {}
}

contract MapSettleTakeHarness is DeltaResolver {
    constructor(MockPoolManagerDR manager) ImmutableState(IPoolManager(address(manager))) {}

    function expose_mapSettleAmount(Currency currency, uint256 amount) external view returns (uint256) {
        return _mapSettleAmount(amount, currency);
    }

    function expose_mapTakeAmount(Currency currency, uint256 amount) external view returns (uint256) {
        return _mapTakeAmount(amount, currency);
    }

    function _pay(Currency, address, uint256) internal override {}
}

contract DeltaResolverMapSettleTakeTest is Test {
    MockPoolManagerDR manager;
    MapSettleTakeHarness harness;
    MockERC20 token;
    Currency tokenCurrency;

    function setUp() public {
        manager = new MockPoolManagerDR();
        harness = new MapSettleTakeHarness(manager);
        token = new MockERC20("T", "T", 18);
        tokenCurrency = Currency.wrap(address(token));
    }

    function test_settle_contractBalance() public {
        token.mint(address(harness), 15);
        uint256 amount = harness.expose_mapSettleAmount(tokenCurrency, ActionConstants.CONTRACT_BALANCE);
        assertEq(amount, 15);
    }

    function test_settle_openDelta_usesDebt() public {
        manager.setDelta(address(harness), tokenCurrency, -8);
        uint256 amount = harness.expose_mapSettleAmount(tokenCurrency, ActionConstants.OPEN_DELTA);
        assertEq(amount, 8);
    }

    function test_settle_openDelta_revertsOnPositiveDelta() public {
        manager.setDelta(address(harness), tokenCurrency, 4);
        vm.expectRevert(abi.encodeWithSelector(DeltaResolver.DeltaNotNegative.selector, tokenCurrency));
        harness.expose_mapSettleAmount(tokenCurrency, ActionConstants.OPEN_DELTA);
    }

    function test_take_openDelta_usesCredit() public {
        manager.setDelta(address(harness), tokenCurrency, 9);
        uint256 amount = harness.expose_mapTakeAmount(tokenCurrency, ActionConstants.OPEN_DELTA);
        assertEq(amount, 9);
    }

    function test_take_openDelta_revertsOnNegativeDelta() public {
        manager.setDelta(address(harness), tokenCurrency, -2);
        vm.expectRevert(abi.encodeWithSelector(DeltaResolver.DeltaNotPositive.selector, tokenCurrency));
        harness.expose_mapTakeAmount(tokenCurrency, ActionConstants.OPEN_DELTA);
    }

    function test_settle_zeroAmount_returnsZero() public view {
        uint256 amount = harness.expose_mapSettleAmount(tokenCurrency, 0);
        assertEq(amount, 0);
    }

    function test_take_zeroAmount_returnsZero() public view {
        uint256 amount = harness.expose_mapTakeAmount(tokenCurrency, 0);
        assertEq(amount, 0);
    }
}

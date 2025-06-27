// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {MockERC20} from "solmate/src/test/utils/mocks/MockERC20.sol";
import {Currency, CurrencyLibrary} from "@uniswap/v4-core/src/types/Currency.sol";
import {DeltaResolver} from "../src/base/DeltaResolver.sol";
import {ImmutableState} from "../src/base/ImmutableState.sol";
import {IPoolManager} from "@uniswap/v4-core/src/interfaces/IPoolManager.sol";
import {ActionConstants} from "../src/libraries/ActionConstants.sol";

contract MockPoolManager {
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

contract MapWrapUnwrapHarness is DeltaResolver {
    constructor(MockPoolManager _manager) ImmutableState(IPoolManager(address(_manager))) {}

    function expose_mapWrapUnwrapAmount(Currency inputCurrency, uint256 amount, Currency outputCurrency)
        external
        view
        returns (uint256)
    {
        return _mapWrapUnwrapAmount(inputCurrency, amount, outputCurrency);
    }

    function _pay(Currency, address, uint256) internal override {}
}

contract DeltaResolverMapWrapUnwrapTest is Test {
    MockPoolManager manager;
    MapWrapUnwrapHarness harness;
    MockERC20 token;
    Currency tokenCurrency;

    function setUp() public {
        manager = new MockPoolManager();
        harness = new MapWrapUnwrapHarness(manager);
        token = new MockERC20("T", "T", 18);
        tokenCurrency = Currency.wrap(address(token));
    }

    function test_contractBalance() public {
        token.mint(address(harness), 20);
        uint256 amount = harness.expose_mapWrapUnwrapAmount(tokenCurrency, ActionConstants.CONTRACT_BALANCE, tokenCurrency);
        assertEq(amount, 20);
    }

    function test_openDeltaUsesDebt() public {
        manager.setDelta(address(harness), tokenCurrency, -7);
        token.mint(address(harness), 10);
        uint256 amount = harness.expose_mapWrapUnwrapAmount(tokenCurrency, ActionConstants.OPEN_DELTA, tokenCurrency);
        assertEq(amount, 7);
    }

    function test_openDelta_revertsInsufficientBalance() public {
        manager.setDelta(address(harness), tokenCurrency, -10);
        token.mint(address(harness), 5);
        vm.expectRevert(DeltaResolver.InsufficientBalance.selector);
        harness.expose_mapWrapUnwrapAmount(tokenCurrency, ActionConstants.OPEN_DELTA, tokenCurrency);
    }

    function test_revertInsufficientBalance() public {
        token.mint(address(harness), 5);
        vm.expectRevert(DeltaResolver.InsufficientBalance.selector);
        harness.expose_mapWrapUnwrapAmount(tokenCurrency, 10, tokenCurrency);
    }

    function test_zeroAmount_returnsZero() public {
        token.mint(address(harness), 5);
        uint256 amount = harness.expose_mapWrapUnwrapAmount(tokenCurrency, 0, tokenCurrency);
        assertEq(amount, 0);
    }

    function test_specificAmount_success() public {
        token.mint(address(harness), 7);
        uint256 amount = harness.expose_mapWrapUnwrapAmount(tokenCurrency, 5, tokenCurrency);
        assertEq(amount, 5);
    }
}


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {IPoolManager} from "@uniswap/v4-core/src/interfaces/IPoolManager.sol";
import {ImmutableState} from "../src/base/ImmutableState.sol";

contract ZeroImmutableState is ImmutableState {
    constructor() ImmutableState(IPoolManager(address(0))) {}

    function callOnlyPoolManager() external onlyPoolManager {}
}

contract ZeroAddressImmutableStateTest is Test {
    ZeroImmutableState harness;

    function setUp() public {
        harness = new ZeroImmutableState();
    }

    function test_onlyPoolManager_reverts() public {
        vm.expectRevert(ImmutableState.NotPoolManager.selector);
        harness.callOnlyPoolManager();
    }
}

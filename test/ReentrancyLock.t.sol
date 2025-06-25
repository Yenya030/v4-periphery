// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {ReentrancyLock} from "../src/base/ReentrancyLock.sol";

contract ReentrancyLockHarness is ReentrancyLock {
    function lockedCaller() external isNotLocked returns (address) {
        return _getLocker();
    }

    function reentrantAttempt() external isNotLocked returns (bool) {
        (bool success,) = address(this).call(abi.encodeWithSelector(this.lockedCaller.selector));
        return success;
    }

    function currentLocker() external view returns (address) {
        return _getLocker();
    }
}

contract ReentrancyLockTest is Test {
    ReentrancyLockHarness harness;

    function setUp() public {
        harness = new ReentrancyLockHarness();
    }

    function test_lock_and_unlock() public {
        address locker = harness.lockedCaller();
        assertEq(locker, address(this));
        assertEq(harness.currentLocker(), address(0));
    }

    function test_reentrant_call_reverts() public {
        bool success = harness.reentrantAttempt();
        assertTrue(!success);
        assertEq(harness.currentLocker(), address(0));
    }
}

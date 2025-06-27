// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {Locker} from "../../src/libraries/Locker.sol";

contract LockerHarness {
    function setLocker(address locker) external {
        Locker.set(locker);
    }

    function setAndReturn(address locker) external returns (address) {
        Locker.set(locker);
        return Locker.get();
    }

    function getLocker() external view returns (address) {
        return Locker.get();
    }
}

contract LockerTest is Test {
    LockerHarness harness;

    function setUp() public {
        harness = new LockerHarness();
    }

    function test_set_and_get_same_tx() public {
        address expected = address(this);
        address result = harness.setAndReturn(expected);
        assertEq(result, expected);
    }

    function test_set_overwrites_existing() public {
        harness.setLocker(address(0xBEEF));
        address result = harness.setAndReturn(address(0xCAFE));
        assertEq(result, address(0xCAFE));
    }

    function test_get_without_set_returns_zero() public {
        assertEq(harness.getLocker(), address(0));
    }

    function test_set_and_get_separate_calls() public {
        address expected = address(0x1234);
        harness.setLocker(expected);
        assertEq(harness.getLocker(), expected);
    }
}

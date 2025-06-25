// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {VanityAddressLib} from "../../src/libraries/VanityAddressLib.sol";

contract VanityAddressLibEdgeHarness {
    function getLeadingNibbleCount(bytes20 addrBytes, uint256 start, uint8 cmp) external pure returns (uint256) {
        return VanityAddressLib.getLeadingNibbleCount(addrBytes, start, cmp);
    }

    function getNibble(bytes20 input, uint256 index) external pure returns (uint8) {
        return VanityAddressLib.getNibble(input, index);
    }
}

contract VanityAddressLibEdgeTest is Test {
    VanityAddressLibEdgeHarness harness;

    function setUp() public {
        harness = new VanityAddressLibEdgeHarness();
    }

    function test_getLeadingNibbleCount_outOfBounds() public {
        bytes20 sample = bytes20(0x1234567890AbcdEF1234567890aBcdef12345678);
        assertEq(harness.getLeadingNibbleCount(sample, 40, 0), 0);
        assertEq(harness.getLeadingNibbleCount(sample, 41, 0), 0);
    }

    function test_getNibble_evenOdd() public {
        bytes20 sample = bytes20(0x1234567890AbcdEF1234567890aBcdef12345678);
        assertEq(harness.getNibble(sample, 0), 0x1);
        assertEq(harness.getNibble(sample, 1), 0x2);
        assertEq(harness.getNibble(sample, 2), 0x3);
        assertEq(harness.getNibble(sample, 3), 0x4);
        assertEq(harness.getNibble(sample, 38), 0x7);
        assertEq(harness.getNibble(sample, 39), 0x8);
    }
}

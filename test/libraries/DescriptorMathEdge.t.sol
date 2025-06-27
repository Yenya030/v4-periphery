// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {DescriptorMathHarness} from "../harness/DescriptorMathHarness.sol";

contract DescriptorMathEdgeTest is Test {
    DescriptorMathHarness harness;

    function setUp() public {
        harness = new DescriptorMathHarness();
    }

    function test_overRange_returnsMinusOne() public {
        assertEq(harness.overRangeExternal(-10, 10, -11), -1);
    }

    function test_overRange_returnsOne() public {
        assertEq(harness.overRangeExternal(-10, 10, 11), 1);
    }

    function test_overRange_returnsZero() public {
        assertEq(harness.overRangeExternal(-10, 10, 0), 0);
    }

    function test_scale_mapsRange() public {
        string memory start = harness.scaleExternal(0, 0, 255, 16, 274);
        string memory middle = harness.scaleExternal(128, 0, 255, 16, 274);
        string memory endv = harness.scaleExternal(255, 0, 255, 16, 274);
        assertEq(start, "16");
        assertEq(middle, "145");
        assertEq(endv, "274");
    }
}

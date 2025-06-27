// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {DescriptorMathHarness} from "../harness/DescriptorMathHarness.sol";

contract DescriptorMathHarnessTest is Test {
    function test_overRange_variants() public pure {
        assertEq(DescriptorMathHarness.overRange(-10, 10, -20), -1);
        assertEq(DescriptorMathHarness.overRange(-10, 10, 20), 1);
        assertEq(DescriptorMathHarness.overRange(-10, 10, 0), 0);
    }

    function test_scale_basic() public pure {
        string memory out = DescriptorMathHarness.scale(10, 0, 20, 100, 200);
        // 10 maps to midpoint 150
        assertEq(out, "150");
    }
}

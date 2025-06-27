// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {Descriptor} from "../../src/libraries/Descriptor.sol";

contract DescriptorFeeStringEdgeTest is Test {
    function test_feeToPercentString_rounding() public pure {
        // 123456 pips should be formatted with full precision
        assertEq(Descriptor.feeToPercentString(123456), "12.3456%");
        // small value with four decimals
        assertEq(Descriptor.feeToPercentString(4205), "0.4205%");
    }
}

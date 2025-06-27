// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import {Test} from "forge-std/Test.sol";
import {Descriptor} from "../../src/libraries/Descriptor.sol";

contract DescriptorDecimalDiffTest is Test {
    function test_fixedPointToDecimalString_diff_gt18_baseGreater() public pure {
        string memory result = Descriptor.fixedPointToDecimalString(uint160(2**96), 40, 0);
        assertEq(result, "1.0000");
    }

    function test_fixedPointToDecimalString_diff_gt18_quoteGreater() public pure {
        string memory result = Descriptor.fixedPointToDecimalString(uint160(2**96), 0, 40);
        assertEq(result, "1.0000");
    }
}

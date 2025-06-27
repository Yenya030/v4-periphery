// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {Descriptor} from "../../src/libraries/Descriptor.sol";

contract DescriptorColorUtilsOffsetLargeTest is Test {
    function test_currencyToColorHex_largeOffset() public pure {
        uint256 currency = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;
        string memory out = Descriptor.currencyToColorHex(currency, 248);
        assertEq(out, "000012");
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {Descriptor} from "../../src/libraries/Descriptor.sol";

contract DescriptorColorUtilsEdgeNewTest is Test {
    function test_currencyToColorHex_offset() public pure {
        uint256 currency = 0x123456;
        string memory out = Descriptor.currencyToColorHex(currency, 8);
        // 0x123456 >> 8 = 0x1234 -> padded to 3 bytes becomes 0x001234
        assertEq(out, "001234");
    }
}

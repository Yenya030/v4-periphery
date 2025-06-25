// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {Descriptor} from "../../src/libraries/Descriptor.sol";

contract DescriptorColorUtilsTest is Test {
    function test_sliceCurrencyHex() public pure {
        uint256 currency = 0xabcdef;
        uint256 result = Descriptor.sliceCurrencyHex(currency, 8);
        // 0xabcdef >> 8 = 0xabcd -> 0xcd
        assertEq(result, 0xcd);
    }

    function test_currencyToColorHex() public pure {
        uint256 currency = 0x123456;
        string memory out = Descriptor.currencyToColorHex(currency, 0);
        assertEq(out, "123456");
    }

    function test_getCircleCoord() public pure {
        uint256 currency = 0xabcdef;
        uint256 tokenId = 3;
        uint256 coord = Descriptor.getCircleCoord(currency, 8, tokenId);
        // sliceCurrencyHex(currency,8) = 0xcd = 205; 205*3 % 255 = 105
        assertEq(coord, 105);
    }
}

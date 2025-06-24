// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {SafeCurrencyMetadata} from "../../src/libraries/SafeCurrencyMetadata.sol";
import {MockNoSymbol} from "./MockNoSymbol.sol";
import {MockBytes32Symbol} from "./MockBytes32Symbol.sol";
import {MockLongSymbol} from "./MockLongSymbol.sol";
import {MockBadDecimals} from "./MockBadDecimals.sol";
import {AddressStringUtil} from "../../src/libraries/AddressStringUtil.sol";

contract SafeCurrencyMetadataTest is Test {
    function test_truncateSymbol_succeeds() public pure {
        // 12 characters
        assertEq(SafeCurrencyMetadata.truncateSymbol("123456789012"), "123456789012");
        // 13 characters
        assertEq(SafeCurrencyMetadata.truncateSymbol("1234567890123"), "123456789012");
        // 14 characters
        assertEq(SafeCurrencyMetadata.truncateSymbol("12345678901234"), "123456789012");
    }

    function test_currencySymbol_native() public view {
        assertEq(SafeCurrencyMetadata.currencySymbol(address(0), "ETH"), "ETH");
    }

    function test_currencySymbol_noSymbol() public {
        MockNoSymbol token = new MockNoSymbol();
        string memory expected = AddressStringUtil.toAsciiString(address(token), 6);
        assertEq(SafeCurrencyMetadata.currencySymbol(address(token), "NATIVE"), expected);
    }

    function test_currencySymbol_bytes32() public {
        MockBytes32Symbol token = new MockBytes32Symbol();
        assertEq(SafeCurrencyMetadata.currencySymbol(address(token), ""), "BYTES32SYM");
    }

    function test_currencySymbol_longString_truncated() public {
        MockLongSymbol token = new MockLongSymbol();
        assertEq(SafeCurrencyMetadata.currencySymbol(address(token), ""), "ABCDEFGHIJKL");
    }

    function test_currencyDecimals_native() public view {
        assertEq(SafeCurrencyMetadata.currencyDecimals(address(0)), 18);
    }

    function test_currencyDecimals_bad() public {
        MockBadDecimals token = new MockBadDecimals();
        assertEq(SafeCurrencyMetadata.currencyDecimals(address(token)), 0);
    }
}

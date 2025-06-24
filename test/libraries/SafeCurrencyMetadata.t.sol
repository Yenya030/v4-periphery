// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {SafeCurrencyMetadata} from "../../src/libraries/SafeCurrencyMetadata.sol";

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

contract MockToken {
    string public symbolReturn;
    uint256 public decimalsReturn;
    bool public revertSymbol;
    bool public revertDecimals;
    constructor(string memory s, uint256 d, bool rS, bool rD) {
        symbolReturn = s;
        decimalsReturn = d;
        revertSymbol = rS;
        revertDecimals = rD;
    }
    function symbol() external view returns (string memory) {
        if (revertSymbol) revert();
        return symbolReturn;
    }
    function decimals() external view returns (uint256) {
        if (revertDecimals) revert();
        return decimalsReturn;
    }
}

contract SafeCurrencyMetadataExtraTest is Test {

    function test_currencySymbol_fallback() public {
        MockToken t = new MockToken("", 18, true, false);
        string memory expected = AddressStringUtil.toAsciiString(address(t), 6);
        assertEq(SafeCurrencyMetadata.currencySymbol(address(t), "N"), expected);
    }

    function test_currencySymbol_truncate() public {
        MockToken t = new MockToken("ABCDEFGHIJKLMNO", 18, false, false);
        assertEq(SafeCurrencyMetadata.currencySymbol(address(t), "N"), "ABCDEFGHIJKL");
    }

    function test_currencyDecimals_standard() public {
        MockToken t = new MockToken("ABC", 18, false, false);
        assertEq(SafeCurrencyMetadata.currencyDecimals(address(t)), 18);
    }

    function test_currencyDecimals_overflow() public {
        MockToken t = new MockToken("ABC", 300, false, false);
        assertEq(SafeCurrencyMetadata.currencyDecimals(address(t)), 0);
    }

    function test_currencyDecimals_revert() public {
        MockToken t = new MockToken("ABC", 18, false, true);
        assertEq(SafeCurrencyMetadata.currencyDecimals(address(t)), 0);
    }
}

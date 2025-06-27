// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {SafeCurrencyMetadata} from "../../src/libraries/SafeCurrencyMetadata.sol";
import {AddressStringUtil} from "../../src/libraries/AddressStringUtil.sol";

contract Bytes32SymbolToken {
    bytes32 private symbolValue;

    constructor(bytes32 s) {
        symbolValue = s;
    }

    function symbol() external view returns (bytes32) {
        return symbolValue;
    }

    function decimals() external pure returns (uint256) {
        return 18;
    }
}

contract StringSymbolToken {
    string private symbolValue;

    constructor(string memory s) {
        symbolValue = s;
    }

    function symbol() external view returns (string memory) {
        return symbolValue;
    }

    function decimals() external pure returns (uint256) {
        return 18;
    }
}

contract StringDecimalsToken {
    string private decimalsValue;

    constructor(string memory d) {
        decimalsValue = d;
    }

    function symbol() external pure returns (string memory) {
        return "T";
    }

    function decimals() external view returns (string memory) {
        return decimalsValue;
    }
}

contract SafeCurrencyMetadataAdditionalTest is Test {
    function test_currencySymbol_bytes32() public {
        Bytes32SymbolToken t = new Bytes32SymbolToken("DAI");
        assertEq(SafeCurrencyMetadata.currencySymbol(address(t), "N"), "DAI");
    }

    function test_currencySymbol_string() public {
        StringSymbolToken t = new StringSymbolToken("XYZ");
        assertEq(SafeCurrencyMetadata.currencySymbol(address(t), "N"), "XYZ");
    }

    function test_currencyDecimals_stringReturn() public {
        StringDecimalsToken t = new StringDecimalsToken("18");
        assertEq(SafeCurrencyMetadata.currencyDecimals(address(t)), 0);
    }
}

contract EmptySymbolToken {
    function symbol() external pure returns (string memory) {
        return "";
    }

    function decimals() external pure returns (uint256) {
        return 18;
    }
}

contract ShortDecimalsToken {
    function symbol() external pure returns (string memory) {
        return "S";
    }

    function decimals() external pure returns (uint256 result) {
        assembly {
            mstore(0x0, 17)
            return(0x0, 31)
        }
    }
}

contract SafeCurrencyMetadataEdgeTest is Test {
    function test_currencySymbol_emptyString() public {
        EmptySymbolToken t = new EmptySymbolToken();
        string memory expected = AddressStringUtil.toAsciiString(address(t), 6);
        assertEq(SafeCurrencyMetadata.currencySymbol(address(t), "N"), expected);
    }

    function test_currencyDecimals_shortReturn() public {
        ShortDecimalsToken t = new ShortDecimalsToken();
        assertEq(SafeCurrencyMetadata.currencyDecimals(address(t)), 0);
    }
}

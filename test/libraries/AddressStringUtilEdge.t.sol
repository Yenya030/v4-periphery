// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {AddressStringUtil} from "../../src/libraries/AddressStringUtil.sol";

contract AddressStringUtilEdgeTest is Test {
    function _call(address a, uint256 len) external pure returns (string memory) {
        return AddressStringUtil.toAsciiString(a, len);
    }

    function charRef(uint8 v) internal pure returns (bytes1 c) {
        return v < 10 ? bytes1(v + 0x30) : bytes1(v + 0x37);
    }

    function test_invalid_length_odd() public {
        vm.expectRevert(abi.encodeWithSelector(AddressStringUtil.InvalidAddressLength.selector, 5));
        this._call(address(0), 5);
    }

    function test_toAsciiString_twoBytes() public {
        address addr = 0x1234567890AbcdEF1234567890aBcdef12345678;
        string memory s = AddressStringUtil.toAsciiString(addr, 2);
        bytes memory b = bytes(s);
        assertEq(b.length, 2);
        uint256 num = uint256(uint160(addr));
        uint8 byteVal = uint8(num >> (8 * 19));
        assertEq(b[0], charRef(byteVal >> 4));
        assertEq(b[1], charRef(byteVal & 0xf));
    }

    function test_toAsciiString_hexLetters() public {
        address addr = address(0xaBcDEf0000000000000000000000000000000000);
        string memory s = AddressStringUtil.toAsciiString(addr, 4);
        assertEq(s, "ABCD");
    }
}

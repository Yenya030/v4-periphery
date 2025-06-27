// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {AddressStringUtil} from "../../src/libraries/AddressStringUtil.sol";

contract AddressStringUtilMoreTest is Test {
    function _call(address a, uint256 len) external pure returns (string memory) {
        return AddressStringUtil.toAsciiString(a, len);
    }

    function test_invalid_length_zero() public {
        vm.expectRevert(abi.encodeWithSelector(AddressStringUtil.InvalidAddressLength.selector, 0));
        this._call(address(0x1234), 0);
    }

    function test_invalid_length_too_big() public {
        vm.expectRevert(abi.encodeWithSelector(AddressStringUtil.InvalidAddressLength.selector, 42));
        this._call(address(0x1234), 42);
    }

    function test_full_length_output() public {
        address addr = 0x1234567890123456789012345678901234567890;
        string memory s = AddressStringUtil.toAsciiString(addr, 40);
        assertEq(s, "1234567890123456789012345678901234567890");
    }

    function test_partial_length_with_letters() public {
        address addr = 0xabCdEF1234567890aBcdefAbCDEFabCdEfAbCdeF;
        string memory s = AddressStringUtil.toAsciiString(addr, 6);
        assertEq(s, "ABCDEF");
    }
}

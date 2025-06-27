// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {DecodeCaller} from "./DecodeCaller.sol";

contract Base64EdgeTest is Test {
    function test_decode_empty() public {
        DecodeCaller caller = new DecodeCaller();
        bytes memory out = caller.callDecode("");
        assertEq(out.length, 0);
    }

    function test_decode_single_padding() public {
        DecodeCaller caller = new DecodeCaller();
        bytes memory out = caller.callDecode("TWE=");
        assertEq(out, bytes("Ma"));
    }

    function test_decode_double_padding() public {
        DecodeCaller caller = new DecodeCaller();
        bytes memory out = caller.callDecode("TQ==");
        assertEq(out, bytes("M"));
    }
}

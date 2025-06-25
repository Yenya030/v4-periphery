// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {DecodeCaller} from "./DecodeCaller.sol";

contract Base64RoundtripTest is Test {
    function test_decode_roundtrip() public {
        DecodeCaller caller = new DecodeCaller();
        bytes memory out = caller.callDecode("dGVzdA==");
        assertEq(out, bytes("test"));
    }
}

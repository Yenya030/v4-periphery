// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {Base64} from "./base64.sol";
import {DecodeCaller} from "./DecodeCaller.sol";

contract Base64Test is Test {
    function test_decode_invalidLength_reverts() public {
        DecodeCaller caller = new DecodeCaller();
        string memory bad = "abcd="; // length 5 not divisible by 4
        vm.expectRevert(bytes("invalid base64 decoder input"));
        caller.callDecode(bad);
    }

    function test_decode_empty_returnsEmptyBytes() public {
        DecodeCaller caller = new DecodeCaller();
        bytes memory result = caller.callDecode("");
        assertEq(result.length, 0);
    }
}

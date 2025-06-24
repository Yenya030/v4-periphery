// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {MockCalldataDecoder} from "test/mocks/MockCalldataDecoder.sol";
import {CalldataDecoder} from "src/libraries/CalldataDecoder.sol";
import "forge-std/Test.sol";

contract CalldataDecoderLengthMismatchTest is Test {
    MockCalldataDecoder decoder;

    function setUp() public {
        decoder = new MockCalldataDecoder();
    }

    function test_truncatedParams_reverts() public {
        bytes memory actions = hex"01";
        bytes[] memory params = new bytes[](1);
        params[0] = hex"abcd";
        bytes memory encoded = abi.encode(actions, params);
        bytes memory malformed = new bytes(encoded.length - 1);
        for (uint256 i; i < malformed.length; i++) {
            malformed[i] = encoded[i];
        }

        vm.expectRevert(CalldataDecoder.SliceOutOfBounds.selector);
        decoder.decodeActionsRouterParams(malformed);

        uint256 actualLength = malformed.length;
        uint256 expectedLength = encoded.length;
        assertEq(expectedLength - actualLength, 1);
    }
}

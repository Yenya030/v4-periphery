pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {MockCalldataDecoder} from "../mocks/MockCalldataDecoder.sol";
import {CalldataDecoder} from "../../src/libraries/CalldataDecoder.sol";

contract CalldataDecoderInvalidOffsetTest is Test {
    MockCalldataDecoder decoder;

    function setUp() public {
        decoder = new MockCalldataDecoder();
    }

    function test_decodeActionsRouterParams_invalidOffset_reverts() public {
        bytes memory actions = hex"01";
        bytes[] memory params = new bytes[](1);
        params[0] = hex"abcd";
        bytes memory data = abi.encode(actions, params);

        // Corrupt the first offset word expected to be 0x40
        assembly {
            mstore(add(data, 0x20), 0x41)
        }

        vm.expectRevert(CalldataDecoder.SliceOutOfBounds.selector);
        decoder.decodeActionsRouterParams(data);
    }
}

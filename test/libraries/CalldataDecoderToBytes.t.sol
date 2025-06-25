pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {CalldataDecoder} from "../../src/libraries/CalldataDecoder.sol";

contract CalldataDecoderToBytesTest is Test {
    using CalldataDecoder for bytes;

    function callToBytes(bytes calldata data, uint256 arg) external pure returns (bytes memory) {
        bytes calldata res = data.toBytes(arg);
        return bytes(res);
    }

    function test_toBytes_extract() public view {
        bytes memory a = hex"abcd";
        bytes memory b = hex"123456";
        bytes memory params = abi.encode(a, b);

        bytes memory out0 = this.callToBytes(params, 0);
        bytes memory out1 = this.callToBytes(params, 1);

        assertEq(out0, a);
        assertEq(out1, b);
    }

    function test_toBytes_sliceOutOfBounds() public {
        bytes memory a = hex"aa";
        bytes memory params = abi.encode(a);
        bytes memory invalid = new bytes(32);
        for (uint256 i; i < invalid.length; i++) {
            invalid[i] = params[i];
        }
        vm.expectRevert(CalldataDecoder.SliceOutOfBounds.selector);
        this.callToBytes(invalid, 0);
    }
}

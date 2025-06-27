// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {MockCalldataDecoder} from "../mocks/MockCalldataDecoder.sol";
import {CalldataDecoder} from "../../src/libraries/CalldataDecoder.sol";
import {IV4Router} from "../../src/interfaces/IV4Router.sol";
import {Currency} from "@uniswap/v4-core/src/types/Currency.sol";
import {PoolKey} from "@uniswap/v4-core/src/types/PoolKey.sol";
import {IHooks} from "@uniswap/v4-core/src/interfaces/IHooks.sol";
import {PathKey} from "../../src/libraries/PathKey.sol";

contract CalldataDecoderSwapShortTest is Test {
    MockCalldataDecoder decoder;

    function setUp() public {
        decoder = new MockCalldataDecoder();
    }

    function _truncate(bytes memory data, uint256 newLength) internal pure returns (bytes memory result) {
        require(newLength < data.length, "length");
        result = new bytes(newLength);
        for (uint256 i = 0; i < newLength; i++) {
            result[i] = data[i];
        }
    }

    function test_decodeSwapExactInParams_shortReverts() public {
        IV4Router.ExactInputParams memory p;
        p.currencyIn = Currency.wrap(address(1));
        p.path = new PathKey[](0);
        p.amountIn = 1;
        p.amountOutMinimum = 1;

        bytes memory params = abi.encode(p);
        bytes memory invalid = _truncate(params, 0xa0 - 1);

        vm.expectRevert(CalldataDecoder.SliceOutOfBounds.selector);
        decoder.decodeSwapExactInParams(invalid);
    }

    function test_decodeSwapExactInSingleParams_shortReverts() public {
        PoolKey memory key = PoolKey({
            currency0: Currency.wrap(address(1)),
            currency1: Currency.wrap(address(2)),
            fee: 3000,
            tickSpacing: 60,
            hooks: IHooks(address(0))
        });
        IV4Router.ExactInputSingleParams memory p = IV4Router.ExactInputSingleParams({
            poolKey: key,
            zeroForOne: true,
            amountIn: 1,
            amountOutMinimum: 1,
            hookData: bytes("")
        });

        bytes memory params = abi.encode(p);
        bytes memory invalid = _truncate(params, 0x140 - 1);

        vm.expectRevert(CalldataDecoder.SliceOutOfBounds.selector);
        decoder.decodeSwapExactInSingleParams(invalid);
    }

    function test_decodeSwapExactOutParams_shortReverts() public {
        IV4Router.ExactOutputParams memory p;
        p.currencyOut = Currency.wrap(address(1));
        p.path = new PathKey[](0);
        p.amountOut = 1;
        p.amountInMaximum = 1;

        bytes memory params = abi.encode(p);
        bytes memory invalid = _truncate(params, 0xa0 - 1);

        vm.expectRevert(CalldataDecoder.SliceOutOfBounds.selector);
        decoder.decodeSwapExactOutParams(invalid);
    }

    function test_decodeSwapExactOutSingleParams_shortReverts() public {
        PoolKey memory key = PoolKey({
            currency0: Currency.wrap(address(1)),
            currency1: Currency.wrap(address(2)),
            fee: 3000,
            tickSpacing: 60,
            hooks: IHooks(address(0))
        });
        IV4Router.ExactOutputSingleParams memory p = IV4Router.ExactOutputSingleParams({
            poolKey: key,
            zeroForOne: true,
            amountOut: 1,
            amountInMaximum: 1,
            hookData: bytes("")
        });

        bytes memory params = abi.encode(p);
        bytes memory invalid = _truncate(params, 0x140 - 1);

        vm.expectRevert(CalldataDecoder.SliceOutOfBounds.selector);
        decoder.decodeSwapExactOutSingleParams(invalid);
    }
}


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {MockCalldataDecoder} from "../mocks/MockCalldataDecoder.sol";
import {CalldataDecoder} from "../../src/libraries/CalldataDecoder.sol";
import {PoolKey} from "@uniswap/v4-core/src/types/PoolKey.sol";
import {IHooks} from "@uniswap/v4-core/src/interfaces/IHooks.sol";
import {Currency} from "@uniswap/v4-core/src/types/Currency.sol";

contract CalldataDecoderEdgeTest is Test {
    MockCalldataDecoder decoder;

    function setUp() public {
        decoder = new MockCalldataDecoder();
    }

    function test_decodeIncreaseLiquidity_emptyHookData() public {
        bytes memory params = abi.encode(uint256(1), uint128(2), uint128(3), bytes(""));
        (uint256 id, uint128 a0, uint128 a1, bytes memory hook) =
            decoder.decodeIncreaseLiquidityFromDeltasParams(params);
        assertEq(id, 1);
        assertEq(a0, 2);
        assertEq(a1, 3);
        assertEq(hook.length, 0);
    }

    function test_decodeMintFromDeltas_emptyHookData() public {
        PoolKey memory key = PoolKey(Currency.wrap(address(1)), Currency.wrap(address(2)), 3000, 60, IHooks(address(0)));
        bytes memory params = abi.encode(key, int24(-1), int24(1), uint128(1), uint128(2), address(3), bytes(""));
        (MockCalldataDecoder.MintFromDeltasParams memory out) = decoder.decodeMintFromDeltasParams(params);
        assertEq(out.owner, address(3));
        assertEq(out.hookData.length, 0);
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {IHooks} from "@uniswap/v4-core/src/interfaces/IHooks.sol";
import {Currency} from "@uniswap/v4-core/src/types/Currency.sol";
import {PoolKey} from "@uniswap/v4-core/src/types/PoolKey.sol";
import {PathKey, PathKeyLibrary} from "../../src/libraries/PathKey.sol";

contract PathKeyEdge is Test {
    function _call(PathKey calldata p, Currency c) external pure returns (PoolKey memory, bool) {
        return PathKeyLibrary.getPoolAndSwapDirection(p, c);
    }

    function test_sameCurrency() public {
        Currency c = Currency.wrap(address(0x1111));
        PathKey memory path = PathKey(c, 3000, 60, IHooks(address(0)), bytes(""));
        (PoolKey memory pool, bool zeroForOne) = this._call(path, c);
        assertTrue(zeroForOne);
        assertEq(Currency.unwrap(pool.currency0), Currency.unwrap(c));
        assertEq(Currency.unwrap(pool.currency1), Currency.unwrap(c));
        assertEq(pool.fee, 3000);
        assertEq(pool.tickSpacing, 60);
    }
}

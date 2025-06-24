// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {LiquidityAmounts} from "../../src/libraries/LiquidityAmounts.sol";
import {FixedPoint96} from "@uniswap/v4-core/src/libraries/FixedPoint96.sol";

contract LiquidityAmountsTest is Test {
    function test_getLiquidityForAmount0_basic() public pure {
        uint160 sqrtPriceA = uint160(FixedPoint96.Q96); // 1
        uint160 sqrtPriceB = uint160(2 * FixedPoint96.Q96); // 2
        uint128 liq = LiquidityAmounts.getLiquidityForAmount0(sqrtPriceA, sqrtPriceB, 1000);
        assertEq(liq, 2000);
    }

    function test_getLiquidityForAmount0_reversed() public pure {
        uint160 sqrtPriceA = uint160(FixedPoint96.Q96);
        uint160 sqrtPriceB = uint160(2 * FixedPoint96.Q96);
        // pass reversed order
        uint128 liq = LiquidityAmounts.getLiquidityForAmount0(sqrtPriceB, sqrtPriceA, 1000);
        assertEq(liq, 2000);
    }

    function test_getLiquidityForAmount1_basic() public pure {
        uint160 sqrtPriceA = uint160(FixedPoint96.Q96);
        uint160 sqrtPriceB = uint160(2 * FixedPoint96.Q96);
        uint128 liq = LiquidityAmounts.getLiquidityForAmount1(sqrtPriceA, sqrtPriceB, 1000);
        assertEq(liq, 1000);
    }

    function test_getLiquidityForAmounts_regions() public pure {
        uint160 sqrtPriceA = uint160(FixedPoint96.Q96);
        uint160 sqrtPriceB = uint160(2 * FixedPoint96.Q96);
        uint160 sqrtPriceXmid = uint160(3 * FixedPoint96.Q96 / 2); // 1.5

        // region 1: price <= sqrtPriceA
        uint128 liq1 = LiquidityAmounts.getLiquidityForAmounts(sqrtPriceA, sqrtPriceA, sqrtPriceB, 1000, 1000);
        assertEq(liq1, 2000);

        // region 2: sqrtPriceA < price < sqrtPriceB
        uint128 liq2 = LiquidityAmounts.getLiquidityForAmounts(sqrtPriceXmid, sqrtPriceA, sqrtPriceB, 1000, 1000);
        assertEq(liq2, 2000);

        // region 3: price >= sqrtPriceB
        uint128 liq3 = LiquidityAmounts.getLiquidityForAmounts(sqrtPriceB, sqrtPriceA, sqrtPriceB, 1000, 1000);
        assertEq(liq3, 1000);
    }
}

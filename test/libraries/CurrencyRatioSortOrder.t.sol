// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {CurrencyRatioSortOrder} from "../../src/libraries/CurrencyRatioSortOrder.sol";

contract CurrencyRatioSortOrderTest is Test {
    function test_constants_values() external {
        assertEq(CurrencyRatioSortOrder.NUMERATOR_MOST, int256(300));
        assertEq(CurrencyRatioSortOrder.NUMERATOR_MORE, int256(200));
        assertEq(CurrencyRatioSortOrder.NUMERATOR, int256(100));
        assertEq(CurrencyRatioSortOrder.DENOMINATOR_MOST, int256(-300));
        assertEq(CurrencyRatioSortOrder.DENOMINATOR_MORE, int256(-200));
        assertEq(CurrencyRatioSortOrder.DENOMINATOR, int256(-100));
    }
}

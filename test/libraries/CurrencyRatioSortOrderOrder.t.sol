// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {CurrencyRatioSortOrder} from "../../src/libraries/CurrencyRatioSortOrder.sol";

/// @notice Additional checks for CurrencyRatioSortOrder constant ordering
contract CurrencyRatioSortOrderOrderTest is Test {
    function test_constant_ordering() external {
        assertGt(CurrencyRatioSortOrder.NUMERATOR_MOST, CurrencyRatioSortOrder.NUMERATOR_MORE);
        assertGt(CurrencyRatioSortOrder.NUMERATOR_MORE, CurrencyRatioSortOrder.NUMERATOR);

        assertLt(CurrencyRatioSortOrder.DENOMINATOR_MOST, CurrencyRatioSortOrder.DENOMINATOR_MORE);
        assertLt(CurrencyRatioSortOrder.DENOMINATOR_MORE, CurrencyRatioSortOrder.DENOMINATOR);

        assertGt(CurrencyRatioSortOrder.NUMERATOR, 0);
        assertLt(CurrencyRatioSortOrder.DENOMINATOR, 0);
    }
}

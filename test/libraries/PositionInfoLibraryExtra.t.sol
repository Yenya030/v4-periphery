// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {PositionInfo, PositionInfoLibrary} from "../../src/libraries/PositionInfoLibrary.sol";

contract PositionInfoLibraryExtraTest is Test {
    function test_empty_position_info_defaults() public pure {
        PositionInfo info = PositionInfoLibrary.EMPTY_POSITION_INFO;
        assertEq(info.poolId(), bytes25(0));
        assertEq(info.tickLower(), 0);
        assertEq(info.tickUpper(), 0);
        assertFalse(info.hasSubscriber());
    }
}

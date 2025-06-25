// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {HexStrings} from "../../src/libraries/HexStrings.sol";

contract HexStringsTest is Test {
    function test_toHexStringNoPrefix_exactLength() public pure {
        string memory hexStr = HexStrings.toHexStringNoPrefix(0xdeadbeef, 4);
        assertEq(hexStr, "deadbeef");
    }

    function test_toHexStringNoPrefix_zeroPadded() public pure {
        string memory hexStr = HexStrings.toHexStringNoPrefix(0x1, 2);
        assertEq(hexStr, "0001");
    }

    function test_toHexStringNoPrefix_truncates_excess() public pure {
        string memory hexStr = HexStrings.toHexStringNoPrefix(0x123456, 2);
        assertEq(hexStr, "3456");
    }
}

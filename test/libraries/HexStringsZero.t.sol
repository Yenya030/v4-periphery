// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {HexStrings} from "../../src/libraries/HexStrings.sol";

contract HexStringsZeroTest is Test {
    function test_toHexStringNoPrefix_zeroValue() public pure {
        string memory hexStr = HexStrings.toHexStringNoPrefix(0, 2);
        assertEq(hexStr, "0000");
    }
}

pragma solidity ^0.8.24;

import {Strings} from "openzeppelin-contracts/contracts/utils/Strings.sol";

contract DescriptorMathHarness {
    using Strings for uint256;

    function overRangeExternal(int24 tickLower, int24 tickUpper, int24 tickCurrent) external pure returns (int8) {
        if (tickCurrent < tickLower) {
            return -1;
        } else if (tickCurrent > tickUpper) {
            return 1;
        } else {
            return 0;
        }
    }

    function scaleExternal(uint256 n, uint256 inMn, uint256 inMx, uint256 outMn, uint256 outMx) external pure returns (string memory) {
        return ((n - inMn) * (outMx - outMn) / (inMx - inMn) + outMn).toString();
    }
}

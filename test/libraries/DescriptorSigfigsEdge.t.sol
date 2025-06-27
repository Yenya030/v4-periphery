// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";

contract DescriptorSigfigsHarness {
    function exposedSigfigsRounded(uint256 value, uint8 digits) external pure returns (uint256, bool) {
        bool extraDigit;
        if (digits > 5) {
            value = value / (10 ** (digits - 5));
        }
        bool roundUp = value % 10 > 4;
        value = value / 10;
        if (roundUp) {
            value = value + 1;
        }
        if (value == 100000) {
            value /= 10;
            extraDigit = true;
        }
        return (value, extraDigit);
    }
}

contract DescriptorSigfigsEdgeTest is Test {
    DescriptorSigfigsHarness harness;

    function setUp() public {
        harness = new DescriptorSigfigsHarness();
    }

    function test_fuzz_extraDigitNeverTrue(uint256 value, uint8 digits) public {
        digits = uint8(bound(digits, 6, 30));
        uint256 min = 10 ** (digits - 1);
        uint256 max = 10 ** digits - 1;
        value = bound(value, min, max);
        (, bool extra) = harness.exposedSigfigsRounded(value, digits);
        assertFalse(extra);
    }
}

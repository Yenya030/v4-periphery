// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {SVG} from "../../src/libraries/SVG.sol";
import {Test} from "forge-std/Test.sol";

contract DescriptorTest is Test {
    function test_rangeLocation_succeeds() public pure {
        (string memory x, string memory y) = SVG.rangeLocation(-887_272, -887_100);
        assertEq(x, "8");
        assertEq(y, "7");
        (x, y) = SVG.rangeLocation(-100_000, -90_000);
        assertEq(x, "8");
        assertEq(y, "10.5");
        (x, y) = SVG.rangeLocation(-50_000, -20_000);
        assertEq(x, "8");
        assertEq(y, "14.25");
        (x, y) = SVG.rangeLocation(-10_000, -5_000);
        assertEq(x, "10");
        assertEq(y, "18");
        (x, y) = SVG.rangeLocation(-5_000, -4_000);
        assertEq(x, "11");
        assertEq(y, "21");
        (x, y) = SVG.rangeLocation(4_000, 5_000);
        assertEq(x, "13");
        assertEq(y, "23");
        (x, y) = SVG.rangeLocation(10_000, 15_000);
        assertEq(x, "15");
        assertEq(y, "25");
        (x, y) = SVG.rangeLocation(25_000, 50_000);
        assertEq(x, "18");
        assertEq(y, "26");
        (x, y) = SVG.rangeLocation(100_000, 125_000);
        assertEq(x, "21");
        assertEq(y, "27");
        (x, y) = SVG.rangeLocation(200_000, 100_000);
        assertEq(x, "24");
        assertEq(y, "27");
        (x, y) = SVG.rangeLocation(887_272, 887_272);
        assertEq(x, "24");
        assertEq(y, "27");
    }

    function test_isRare_succeeds() public pure {
        bool result = SVG.isRare(1, 0xbBbBBBBbbBBBbbbBbbBbbbbBBbBbbbbBbBbbBBbB);
        assertTrue(result);
        result = SVG.isRare(2, 0xbBbBBBBbbBBBbbbBbbBbbbbBBbBbbbbBbBbbBBbB);
        assertFalse(result);
    }

    function test_substring_succeeds() public pure {
        string memory result = SVG.substring("0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2", 0, 5);
        assertEq(result, "0xC02");
        result = SVG.substring("0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2", 39, 42);
        assertEq(result, "Cc2");
    }

    function test_getCurve_boundaries() public pure {
        assertEq(SVG.getCurve(0, 4, 1), "M1 1C41 41 105 105 145 145");
        assertEq(SVG.getCurve(0, 8, 1), "M1 1C33 49 97 113 145 145");
        assertEq(SVG.getCurve(0, 16, 1), "M1 1C33 57 89 113 145 145");
        assertEq(SVG.getCurve(0, 32, 1), "M1 1C25 65 81 121 145 145");
        assertEq(SVG.getCurve(0, 64, 1), "M1 1C17 73 73 129 145 145");
        assertEq(SVG.getCurve(0, 128, 1), "M1 1C9 81 65 137 145 145");
        assertEq(SVG.getCurve(0, 256, 1), "M1 1C1 89 57.5 145 145 145");
        assertEq(SVG.getCurve(0, 300, 1), "M1 1C1 97 49 145 145 145");
    }

    function test_generateSVGCurveCircle_variants() public pure {
        string memory expectedInRange = string(
            abi.encodePacked(
                '<circle cx="73px" cy="190px" r="4px" fill="white" />',
                '<circle cx="217px" cy="334px" r="4px" fill="white" />'
            )
        );
        assertEq(SVG.generateSVGCurveCircle(0), expectedInRange);

        string memory expectedUnder = string(
            abi.encodePacked(
                '<circle cx="73px" cy="190px" r="4px" fill="white" />',
                '<circle cx="73px" cy="190px" r="24px" fill="none" stroke="white" />'
            )
        );
        assertEq(SVG.generateSVGCurveCircle(-1), expectedUnder);

        string memory expectedOver = string(
            abi.encodePacked(
                '<circle cx="217px" cy="334px" r="4px" fill="white" />',
                '<circle cx="217px" cy="334px" r="24px" fill="none" stroke="white" />'
            )
        );
        assertEq(SVG.generateSVGCurveCircle(1), expectedOver);
    }
}

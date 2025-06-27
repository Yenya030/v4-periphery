// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {SVG} from "../../src/libraries/SVG.sol";
import {SVGHarness} from "../harness/SVGHarness.sol";

contract SVGExtendedTest is Test {
    SVGHarness harness;

    function setUp() public {
        harness = new SVGHarness();
    }

    function test_tickToString_variants() public {
        assertEq(harness.tickToString(-123), "-123");
        assertEq(harness.tickToString(0), "0");
        assertEq(harness.tickToString(456), "456");
    }

    function _contains(string memory haystack, string memory needle) internal pure returns (bool) {
        bytes memory h = bytes(haystack);
        bytes memory n = bytes(needle);
        if (n.length > h.length) return false;
        bool found;
        for (uint256 i; i <= h.length - n.length; i++) {
            found = true;
            for (uint256 j; j < n.length; j++) {
                if (h[i + j] != n[j]) { found = false; break; }
            }
            if (found) return true;
        }
        return false;
    }


    function test_generateSVGRareSparkle_whenRare() public {
        string memory svg = harness.generateSVGRareSparkle(1, 0xbBbBBBBbbBBBbbbBbbBbbbbBBbBbbbbBbBbbBBbB);
        assertTrue(_contains(svg, "<animateTransform"));
    }

    function test_generateSVGRareSparkle_whenNotRare() public {
        string memory svg = harness.generateSVGRareSparkle(2, 0xbBbBBBBbbBBBbbbBbbBbbbbBBbBbbbbBbBbbBBbB);
        assertEq(svg, "");
    }

    function test_substring_outOfBounds_reverts() public {
        vm.expectRevert(stdError.indexOOBError);
        harness.substringExternal("hello", 0, 6);
    }

    function test_substring_startGreaterThanEnd_reverts() public {
        vm.expectRevert(stdError.arithmeticError);
        harness.substringExternal("hello", 6, 3);
    }

    function test_substring_empty_result() public {
        string memory result = harness.substringExternal("hello", 2, 2);
        assertEq(result, "");
    }
}

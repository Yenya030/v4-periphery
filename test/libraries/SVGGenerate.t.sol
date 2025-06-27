// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {SVGHarness} from "../harness/SVGHarness.sol";

contract SVGGenerateTest is Test {
    SVGHarness harness;

    function setUp() public {
        harness = new SVGHarness();
    }

    function _contains(string memory haystack, string memory needle) internal pure returns (bool) {
        bytes memory h = bytes(haystack);
        bytes memory n = bytes(needle);
        if (n.length > h.length) return false;
        for (uint256 i; i <= h.length - n.length; i++) {
            bool match_ = true;
            for (uint256 j; j < n.length; j++) {
                if (h[i + j] != n[j]) {
                    match_ = false;
                    break;
                }
            }
            if (match_) return true;
        }
        return false;
    }

    function test_generateSVGCardMantle_contains_symbols() public {
        string memory svg = harness.generateSVGCardMantleExternal("AAA", "BBB", "3000");
        assertTrue(bytes(svg).length > 0);
        assertTrue(_contains(svg, "AAA"));
        assertTrue(_contains(svg, "BBB"));
    }
}

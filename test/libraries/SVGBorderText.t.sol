// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {SVGHarness} from "../harness/SVGHarness.sol";

contract SVGBorderTextTest is Test {
    SVGHarness harness;

    function setUp() public {
        harness = new SVGHarness();
    }

    function _contains(string memory haystack, string memory needle) internal pure returns (bool) {
        bytes memory h = bytes(haystack);
        bytes memory n = bytes(needle);
        if (n.length > h.length) return false;
        bool found;
        for (uint256 i; i <= h.length - n.length; i++) {
            found = true;
            for (uint256 j; j < n.length; j++) {
                if (h[i + j] != n[j]) {
                    found = false;
                    break;
                }
            }
            if (found) return true;
        }
        return false;
    }

    function test_generateSVGBorderText_containsInputs() public {
        string memory svg = harness.generateSVGBorderTextExternal("USD", "ETH", "U", "E");
        assertTrue(_contains(svg, "USD"));
        assertTrue(_contains(svg, "ETH"));
        assertTrue(_contains(svg, "U"));
        assertTrue(_contains(svg, "E"));
    }
}

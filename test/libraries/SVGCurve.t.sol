// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {SVG} from "../../src/libraries/SVG.sol";
import {SVGHarness} from "../harness/SVGHarness.sol";

contract SVGCurveTest is Test {
    SVGHarness harness = new SVGHarness();

    function test_generageSvgCurve_inRange() public {
        string memory curve = SVG.getCurve(0, 16, 1);
        string memory expected = string(
            abi.encodePacked(
                '<g mask="url(#none)" style="transform:translate(72px,189px)"><rect x="-16px" y="-16px" width="180px" height="180px" fill="none" />',
                '<path d="',
                curve,
                '" stroke="rgba(0,0,0,0.3)" stroke-width="32px" fill="none" stroke-linecap="round" />',
                '</g><g mask="url(#none)" style="transform:translate(72px,189px)"><rect x="-16px" y="-16px" width="180px" height="180px" fill="none" />',
                '<path d="',
                curve,
                '" stroke="rgba(255,255,255,1)" fill="none" stroke-linecap="round" /></g>',
                SVG.generateSVGCurveCircle(0)
            )
        );
        assertEq(harness.generageSvgCurveExternal(0, 16, 1, 0), expected);
    }
}

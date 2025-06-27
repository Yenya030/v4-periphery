// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {QuoterRevert} from "../../src/libraries/QuoterRevert.sol";

contract QuoterRevertWrapperShort {
    function callParse(bytes calldata data) external pure returns (uint256) {
        return QuoterRevert.parseQuoteAmount(data);
    }
}

contract QuoterRevertEdgeShortTest is Test {
    QuoterRevertWrapperShort wrapper;

    function setUp() public {
        wrapper = new QuoterRevertWrapperShort();
    }

    function test_parseQuoteAmount_shortSelector() public {
        bytes memory data = abi.encodePacked(QuoterRevert.QuoteSwap.selector);
        uint256 parsed = wrapper.callParse(data);
        assertEq(parsed, 0);
    }
}

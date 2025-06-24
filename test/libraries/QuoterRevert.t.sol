// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {QuoterRevert} from "../../src/libraries/QuoterRevert.sol";

contract QuoterRevertWrapper {
    function callRevertQuote(uint256 amount) external pure {
        QuoterRevert.revertQuote(amount);
    }

    function callBubble(bytes calldata data) external pure {
        QuoterRevert.bubbleReason(data);
    }

    function callParse(bytes calldata data) external pure returns (uint256) {
        return QuoterRevert.parseQuoteAmount(data);
    }
}

contract QuoterRevertTest is Test {
    QuoterRevertWrapper wrapper;

    function setUp() public {
        wrapper = new QuoterRevertWrapper();
    }

    function test_revertQuote_and_parse() public {
        uint256 amount = 123;
        bytes memory revertData = abi.encodeWithSelector(QuoterRevert.QuoteSwap.selector, amount);
        vm.expectRevert(revertData);
        wrapper.callRevertQuote(amount);

        uint256 parsed = wrapper.callParse(revertData);
        assertEq(parsed, amount);
    }

    function test_parseQuoteAmount_invalid_selector() public {
        bytes memory data = abi.encodeWithSelector(bytes4(0xdeadbeef), uint256(1));
        vm.expectRevert(abi.encodeWithSelector(QuoterRevert.UnexpectedRevertBytes.selector, data));
        wrapper.callParse(data);
    }

    function test_bubbleReason() public {
        bytes memory data = hex"11223344";
        vm.expectRevert(data);
        wrapper.callBubble(data);
    }
}


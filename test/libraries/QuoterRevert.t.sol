// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {QuoterRevert} from "../../src/libraries/QuoterRevert.sol";

contract QuoterRevertHarness {
    function doRevertQuote(uint256 amount) external pure {
        QuoterRevert.revertQuote(amount);
    }

    function bubble(bytes memory data) external pure {
        QuoterRevert.bubbleReason(data);
    }

    function parse(bytes memory data) external pure returns (uint256) {
        return QuoterRevert.parseQuoteAmount(data);
    }
}

contract QuoterRevertTest is Test {
    QuoterRevertHarness harness = new QuoterRevertHarness();

    function test_revertQuote_encodesAmount() public {
        uint256 amt = 42;
        bytes memory expected = abi.encodeWithSelector(QuoterRevert.QuoteSwap.selector, amt);
        vm.expectRevert(expected);
        harness.doRevertQuote(amt);
    }

    function test_parseQuoteAmount_valid() public {
        uint256 amt = 123;
        bytes memory data = abi.encodeWithSelector(QuoterRevert.QuoteSwap.selector, amt);
        uint256 parsed = harness.parse(data);
        assertEq(parsed, amt);
    }

    function test_parseQuoteAmount_invalid_reverts() public {
        bytes memory bad = abi.encodeWithSignature("BadError()");
        vm.expectRevert(abi.encodeWithSelector(QuoterRevert.UnexpectedRevertBytes.selector, bad));
        harness.parse(bad);
    }

    function test_bubbleReason_reverts_with_same_data() public {
        bytes memory data = abi.encodeWithSignature("SomeError(uint256)", 1);
        vm.expectRevert(data);
        harness.bubble(data);
    }
}

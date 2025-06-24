// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {QuoterRevert} from "../../src/libraries/QuoterRevert.sol";

contract QuoterRevertTarget {
    function trigger(uint256 amount) external pure {
        QuoterRevert.revertQuote(amount);
    }
}

contract QuoterRevertHelper {
    function parse(bytes calldata reason) external pure returns (uint256) {
        return QuoterRevert.parseQuoteAmount(reason);
    }
}

contract QuoterRevertTest is Test {
    function test_parseQuoteAmount_valid() public {
        QuoterRevertTarget target = new QuoterRevertTarget();
        uint256 quoteAmount = 123456;
        try target.trigger(quoteAmount) {
            fail();
        } catch (bytes memory reason) {
            QuoterRevertHelper helper = new QuoterRevertHelper();
            uint256 parsed = helper.parse(reason);
            assertEq(parsed, quoteAmount);
        }
    }

    function test_parseQuoteAmount_invalid() public {
        QuoterRevertHelper helper = new QuoterRevertHelper();
        bytes memory bad = abi.encodeWithSignature("SomeError()");
        vm.expectRevert(abi.encodeWithSelector(QuoterRevert.UnexpectedRevertBytes.selector, bad));
        helper.parse(bad);
    }
}

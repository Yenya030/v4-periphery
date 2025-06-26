// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {SlippageCheck} from "../../src/libraries/SlippageCheck.sol";
import {BalanceDelta, toBalanceDelta} from "../../lib/v4-core/src/types/BalanceDelta.sol";
import {SafeCast} from "../../lib/v4-core/src/libraries/SafeCast.sol";

contract SlippageHarness {
    function callValidateMaxIn(BalanceDelta delta, uint128 max0, uint128 max1) external pure {
        SlippageCheck.validateMaxIn(delta, max0, max1);
    }

    function callValidateMinOut(BalanceDelta delta, uint128 min0, uint128 min1) external pure {
        SlippageCheck.validateMinOut(delta, min0, min1);
    }
}

contract SlippageCheckTest is Test {
    SlippageHarness harness;

    function setUp() public {
        harness = new SlippageHarness();
    }

    function test_validateMaxIn_positiveDelta() public {
        BalanceDelta delta = toBalanceDelta(5, 3);
        harness.callValidateMaxIn(delta, 1, 1);
    }

    function test_validateMaxIn_exceeds() public {
        BalanceDelta delta = toBalanceDelta(-6, 0);
        vm.expectRevert();
        harness.callValidateMaxIn(delta, 5, 100);
    }

    function test_validateMinOut_negativeDelta_overflow() public {
        BalanceDelta delta = toBalanceDelta(-1, 0);
        vm.expectRevert();
        harness.callValidateMinOut(delta, 1, 0);
    }

    function test_validateMaxIn_withinLimits() public {
        BalanceDelta delta = toBalanceDelta(-5, -3);
        harness.callValidateMaxIn(delta, 5, 3);
    }

    function test_validateMinOut_succeeds() public {
        BalanceDelta delta = toBalanceDelta(5, 6);
        harness.callValidateMinOut(delta, 5, 6);
    }

    function test_validateMinOut_revert_amount0() public {
        BalanceDelta delta = toBalanceDelta(4, 10);
        vm.expectRevert(
            abi.encodeWithSelector(SlippageCheck.MinimumAmountInsufficient.selector, uint128(5), uint128(4))
        );
        harness.callValidateMinOut(delta, 5, 9);
    }

    function test_validateMinOut_revert_amount1() public {
        BalanceDelta delta = toBalanceDelta(10, 2);
        vm.expectRevert(
            abi.encodeWithSelector(SlippageCheck.MinimumAmountInsufficient.selector, uint128(3), uint128(2))
        );
        harness.callValidateMinOut(delta, 9, 3);
    }
}

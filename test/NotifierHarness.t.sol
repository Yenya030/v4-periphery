// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {NotifierHarness} from "./mocks/NotifierHarness.sol";
import {SimpleSubscriber} from "./mocks/SimpleSubscriber.sol";
import {SimpleRevertSubscriber} from "./mocks/SimpleRevertSubscriber.sol";
import {INotifier} from "../src/interfaces/INotifier.sol";
import {PositionInfo} from "../src/libraries/PositionInfoLibrary.sol";
import {BalanceDelta} from "@uniswap/v4-core/src/types/BalanceDelta.sol";

contract NotifierHarnessTest is Test {
    NotifierHarness harness;

    function setUp() public {
        harness = new NotifierHarness(100000);
    }

    function test_call_noCode_reverts() public {
        vm.expectRevert(INotifier.NoCodeSubscriber.selector);
        harness.callWrap(address(0x1234), hex"");
    }

    function test_unsubscribe_reverts_when_not_subscribed() public {
        vm.expectRevert(INotifier.NotSubscribed.selector);
        harness.unsubscribeWrap(1);
    }

    function test_unsubscribe_notifies() public {
        SimpleSubscriber sub = new SimpleSubscriber();
        harness.subscribe(1, address(sub), "");
        harness.unsubscribeWrap(1);
        assertEq(sub.unsubscribeCount(), 1);
    }

    function test_removeSubscriberAndNotifyBurn() public {
        SimpleSubscriber sub = new SimpleSubscriber();
        harness.subscribe(2, address(sub), "");
        harness.removeSubscriberAndNotifyBurn(2, address(this), PositionInfo.wrap(0), 0, BalanceDelta.wrap(0));
        assertEq(sub.burnCount(), 1);
        assertEq(address(harness.subscriber(2)), address(0));
    }

    function test_notifyModifyLiquidity_revertBubbles() public {
        SimpleRevertSubscriber sub = new SimpleRevertSubscriber();
        harness.subscribe(3, address(sub), "");
        vm.expectRevert();
        harness.notifyModifyLiquidityWrap(3, 1, BalanceDelta.wrap(0));
    }
}

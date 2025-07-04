// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {NotifierHarness} from "../mocks/NotifierHarness.sol";
import {GasGriefSubscriber} from "../mocks/GasGriefSubscriber.sol";
import {INotifier} from "../../src/interfaces/INotifier.sol";

contract NotifierGasGriefTest is Test {
    NotifierHarness notifier;
    GasGriefSubscriber sub;

    function setUp() public {
        notifier = new NotifierHarness(100000);
        sub = new GasGriefSubscriber();
        notifier.subscribe(1, address(sub), "");
    }

    function test_unsubscribe_gas_grief() public {
        uint256 gasLimit = notifier.unsubscribeGasLimit();
        vm.expectRevert();
        notifier.unsubscribeWrap{gas: gasLimit - 1}(1);
        assertEq(address(notifier.subscriber(1)), address(sub));
    }
}

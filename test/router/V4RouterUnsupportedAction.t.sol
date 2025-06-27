// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {RoutingTestHelpers} from "../shared/RoutingTestHelpers.sol";
import {Planner} from "../shared/Planner.sol";
import {BaseActionsRouter} from "../../src/base/BaseActionsRouter.sol";

contract V4RouterUnsupportedActionTest is RoutingTestHelpers {
    function setUp() public {
        setupRouterCurrenciesAndPoolsWithLiquidity();
        plan = Planner.init();
    }

    function test_executeActions_unsupportedAction_reverts() public {
        plan = plan.add(0xff, "");
        vm.expectRevert(abi.encodeWithSelector(BaseActionsRouter.UnsupportedAction.selector, uint256(0xff)));
        router.executeActions(plan.encode());
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {MockBaseActionsRouter} from "./mocks/MockBaseActionsRouter.sol";
import {Planner} from "./shared/Planner.sol";
import {Test} from "forge-std/Test.sol";
import {Deployers} from "@uniswap/v4-core/test/utils/Deployers.sol";

contract BaseActionsRouterZeroTest is Test, Deployers {
    MockBaseActionsRouter router;

    function setUp() public {
        deployFreshManager();
        router = new MockBaseActionsRouter(manager);
    }

    function test_executeActions_zeroActions_noop() public {
        bytes memory data = Planner.init().encode();
        router.executeActions(data);
        assertEq(router.swapCount(), 0);
        assertEq(router.mintCount(), 0);
    }
}

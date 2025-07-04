// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {Planner} from "../shared/Planner.sol";
import {Actions} from "../../src/libraries/Actions.sol";
import {ReentrancyLock} from "../../src/base/ReentrancyLock.sol";
import {IPoolManager} from "@uniswap/v4-core/src/interfaces/IPoolManager.sol";
import {BalanceDelta} from "@uniswap/v4-core/src/types/BalanceDelta.sol";

import {MockPoolManagerUnlock} from "../mocks/MockPoolManagerUnlock.sol";
import {MockBaseActionsRouter} from "../mocks/MockBaseActionsRouter.sol";
import {MalSubscriber} from "../mocks/MalSubscriber.sol";

contract ReentrantUnlockTest is Test {
    MockPoolManagerUnlock manager;
    MockBaseActionsRouter router;

    function setUp() public {
        manager = new MockPoolManagerUnlock();
        router = new MockBaseActionsRouter(IPoolManager(address(manager)));
    }

    function test_reentrant_unlock_reverts() public {
        bytes memory plan = Planner.init().add(Actions.DONATE, "").encode();
        MalSubscriber mal = new MalSubscriber(router, plan);
        manager.setSubscriber(mal);

        vm.expectRevert(abi.encodeWithSelector(ReentrancyLock.ContractLocked.selector));
        router.executeActions(plan);
    }
}

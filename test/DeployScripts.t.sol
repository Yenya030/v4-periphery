// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";

import {DeployPosmTest} from "../script/DeployPosm.s.sol";
import {DeployStateView} from "../script/DeployStateView.s.sol";
import {DeployV4Quoter} from "../script/DeployV4Quoter.s.sol";

import {IPositionManager} from "../src/interfaces/IPositionManager.sol";
import {IPositionDescriptor} from "../src/interfaces/IPositionDescriptor.sol";
import {IStateView} from "../src/interfaces/IStateView.sol";
import {IV4Quoter} from "../src/interfaces/IV4Quoter.sol";

contract DeployScriptsTest is Test {
    DeployPosmTest private posmScript;
    DeployStateView private stateScript;
    DeployV4Quoter private quoterScript;

    address private constant POOL_MANAGER = address(0x1234);
    address private constant PERMIT2 = address(0x5678);
    uint256 private constant GAS_LIMIT = 500000;
    address private constant WRAPPED_NATIVE = address(0x9abc);
    bytes32 private constant LABEL_BYTES = bytes32("ETH");

    function setUp() public {
        posmScript = new DeployPosmTest();
        stateScript = new DeployStateView();
        quoterScript = new DeployV4Quoter();
    }

    function test_runDeployPosm() public {
        (IPositionDescriptor desc, IPositionManager manager) =
            posmScript.run(POOL_MANAGER, PERMIT2, GAS_LIMIT, WRAPPED_NATIVE, LABEL_BYTES);

        assertEq(address(manager.poolManager()), POOL_MANAGER);
        assertEq(address(desc.poolManager()), POOL_MANAGER);
    }

    function test_runDeployStateView() public {
        IStateView state = stateScript.run(POOL_MANAGER);
        assertEq(address(state.poolManager()), POOL_MANAGER);
    }

    function test_runDeployV4Quoter() public {
        IV4Quoter quoter = quoterScript.run(POOL_MANAGER);
        assertEq(address(quoter.poolManager()), POOL_MANAGER);
    }
}

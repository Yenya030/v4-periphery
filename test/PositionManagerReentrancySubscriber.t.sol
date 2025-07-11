// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";

import {PositionManager} from "../src/PositionManager.sol";
import {MockPoolManagerSimple} from "./mocks/MockPoolManagerSimple.sol";
import {MaliciousSubscriber} from "./mocks/MaliciousSubscriber.sol";
import {PoolKey} from "@uniswap/v4-core/src/types/PoolKey.sol";
import {Currency} from "@uniswap/v4-core/src/types/Currency.sol";
import {IHooks} from "@uniswap/v4-core/src/interfaces/IHooks.sol";
import {Actions} from "../src/libraries/Actions.sol";
import {IPositionDescriptor} from "../src/interfaces/IPositionDescriptor.sol";
import {IWETH9} from "../src/interfaces/external/IWETH9.sol";
import {IPositionManager} from "../src/interfaces/IPositionManager.sol";
import {IPoolManager} from "@uniswap/v4-core/src/interfaces/IPoolManager.sol";
import {IAllowanceTransfer} from "permit2/src/interfaces/IAllowanceTransfer.sol";
import {CustomRevert} from "@uniswap/v4-core/src/libraries/CustomRevert.sol";
import {INotifier} from "../src/interfaces/INotifier.sol";
import {ISubscriber} from "../src/interfaces/ISubscriber.sol";

contract PositionManagerReentrancySubscriberTest is Test {
    MockPoolManagerSimple poolManager;
    PositionManager posm;
    MaliciousSubscriber subscriber;

    function setUp() public {
        poolManager = new MockPoolManagerSimple();
        posm = new PositionManager(
            IPoolManager(address(poolManager)),
            IAllowanceTransfer(address(0)),
            0,
            IPositionDescriptor(address(0)),
            IWETH9(address(0))
        );
        subscriber = new MaliciousSubscriber(posm);
    }

    function test_ReentrancyPreventsERC721Transfer() public {
        PoolKey memory key = PoolKey({
            currency0: Currency.wrap(address(1)),
            currency1: Currency.wrap(address(2)),
            fee: 0,
            tickSpacing: 1,
            hooks: IHooks(address(0))
        });

        bytes memory actions = new bytes(1);
        actions[0] = bytes1(uint8(Actions.MINT_POSITION));
        bytes[] memory params = new bytes[](1);
        params[0] = abi.encode(key, int24(-1), int24(1), uint256(0), uint128(0), uint128(0), address(subscriber), bytes(""));

        bytes memory data = abi.encode(actions, params);
        vm.prank(address(subscriber));
        posm.modifyLiquidities(data, block.timestamp + 1);

        uint256 tokenId = posm.nextTokenId() - 1;
        subscriber.setTokenId(tokenId);

        vm.prank(address(subscriber));
        posm.subscribe(tokenId, address(subscriber), "");

        actions[0] = bytes1(uint8(Actions.INCREASE_LIQUIDITY));
        params[0] = abi.encode(tokenId, uint256(0), uint128(0), uint128(0), bytes(""));
        data = abi.encode(actions, params);

        vm.expectRevert(
            abi.encodeWithSelector(
                CustomRevert.WrappedError.selector,
                address(subscriber),
                ISubscriber.notifyModifyLiquidity.selector,
                abi.encodeWithSelector(IPositionManager.PoolManagerMustBeLocked.selector),
                abi.encodeWithSelector(INotifier.ModifyLiquidityNotificationReverted.selector)
            )
        );
        vm.prank(address(subscriber));
        posm.modifyLiquidities(data, block.timestamp + 1);
    }
}

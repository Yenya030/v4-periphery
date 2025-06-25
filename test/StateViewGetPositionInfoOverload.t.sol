// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {TickMath} from "@uniswap/v4-core/src/libraries/TickMath.sol";
import {PoolKey} from "@uniswap/v4-core/src/types/PoolKey.sol";
import {PoolId} from "@uniswap/v4-core/src/types/PoolId.sol";
import {Position} from "@uniswap/v4-core/src/libraries/Position.sol";
import {IHooks} from "@uniswap/v4-core/src/interfaces/IHooks.sol";
import {Deployers} from "@uniswap/v4-core/test/utils/Deployers.sol";
import {BalanceDelta} from "@uniswap/v4-core/src/types/BalanceDelta.sol";

import {Deploy, IStateView} from "./shared/Deploy.sol";
import {ModifyLiquidityParams} from "@uniswap/v4-core/src/types/PoolOperation.sol";

contract StateViewGetPositionInfoOverload is Test, Deployers {
    IStateView state;
    PoolId poolId;

    function setUp() public {
        deployFreshManagerAndRouters();
        deployMintAndApprove2Currencies();
        key = PoolKey(currency0, currency1, 3000, 60, IHooks(address(0)));
        poolId = key.toId();
        manager.initialize(key, TickMath.getSqrtPriceAtTick(0));
        state = Deploy.stateView(address(manager), hex"00");
    }

    function test_getPositionInfo_overload() public {
        modifyLiquidityRouter.modifyLiquidity(key, ModifyLiquidityParams(-60, 60, 10_000 ether, 0), "");
        // update position to accrue fees
        swap(key, true, -1 ether, "");
        modifyLiquidityRouter.modifyLiquidity(key, ModifyLiquidityParams(-60, 60, 0, 0), "");

        bytes32 positionId = Position.calculatePositionKey(address(modifyLiquidityRouter), -60, 60, bytes32(0));
        (uint128 liq1, uint256 f0a, uint256 f1a) = state.getPositionInfo(poolId, positionId);
        (uint128 liq2, uint256 f0b, uint256 f1b) = state.getPositionInfo(poolId, address(modifyLiquidityRouter), -60, 60, bytes32(0));

        assertEq(liq1, liq2);
        assertEq(f0a, f0b);
        assertEq(f1a, f1b);
    }
}

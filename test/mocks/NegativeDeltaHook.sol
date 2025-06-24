// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {BaseTestHooks} from "@uniswap/v4-core/src/test/BaseTestHooks.sol";
import {PoolKey} from "@uniswap/v4-core/src/types/PoolKey.sol";
import {BalanceDelta, toBalanceDelta} from "@uniswap/v4-core/src/types/BalanceDelta.sol";
import {ModifyLiquidityParams} from "@uniswap/v4-core/src/types/PoolOperation.sol";

/// @notice Hook that always returns a negative liquidity delta on removal
contract NegativeDeltaHook is BaseTestHooks {
    int128 public delta;

    function setDelta(int128 _delta) external {
        delta = _delta;
    }

    function afterRemoveLiquidity(
        address,
        PoolKey calldata,
        ModifyLiquidityParams calldata,
        BalanceDelta,
        BalanceDelta,
        bytes calldata
    ) external override returns (bytes4, BalanceDelta) {
        return (NegativeDeltaHook.afterRemoveLiquidity.selector, toBalanceDelta(delta, 0));
    }
}

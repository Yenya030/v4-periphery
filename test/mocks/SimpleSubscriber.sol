// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ISubscriber} from "../../src/interfaces/ISubscriber.sol";
import {PositionInfo} from "../../src/libraries/PositionInfoLibrary.sol";
import {BalanceDelta} from "@uniswap/v4-core/src/types/BalanceDelta.sol";

contract SimpleSubscriber is ISubscriber {
    uint256 public subscribeCount;
    uint256 public unsubscribeCount;
    uint256 public modifyCount;
    uint256 public burnCount;

    function notifySubscribe(uint256, bytes memory) external override {
        subscribeCount++;
    }

    function notifyUnsubscribe(uint256) external override {
        unsubscribeCount++;
    }

    function notifyBurn(uint256, address, PositionInfo, uint256, BalanceDelta) external override {
        burnCount++;
    }

    function notifyModifyLiquidity(uint256, int256, BalanceDelta) external override {
        modifyCount++;
    }
}

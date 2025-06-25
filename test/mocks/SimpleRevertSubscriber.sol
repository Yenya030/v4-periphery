// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ISubscriber} from "../../src/interfaces/ISubscriber.sol";
import {BalanceDelta} from "@uniswap/v4-core/src/types/BalanceDelta.sol";
import {PositionInfo} from "../../src/libraries/PositionInfoLibrary.sol";

contract SimpleRevertSubscriber is ISubscriber {
    function notifySubscribe(uint256, bytes memory) external pure override {}

    function notifyUnsubscribe(uint256) external pure override {}

    function notifyBurn(uint256, address, PositionInfo, uint256, BalanceDelta) external pure override {}

    function notifyModifyLiquidity(uint256, int256, BalanceDelta) external pure override {
        revert("notifyModifyLiquidity");
    }
}

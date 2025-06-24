// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ISubscriber} from "../../src/interfaces/ISubscriber.sol";
import {IPositionManager} from "../../src/interfaces/IPositionManager.sol";
import {BalanceDelta} from "@uniswap/v4-core/src/types/BalanceDelta.sol";
import {PositionInfo} from "../../src/libraries/PositionInfoLibrary.sol";

/// @notice Subscriber that reverts on notifyBurn to test revert wrapping
contract MockBurnRevertSubscriber is ISubscriber {
    IPositionManager posm;

    error NotAuthorizedNotifier(address sender);

    constructor(IPositionManager _posm) {
        posm = _posm;
    }

    modifier onlyByPosm() {
        if (msg.sender != address(posm)) revert NotAuthorizedNotifier(msg.sender);
        _;
    }

    function notifySubscribe(uint256, bytes memory) external override onlyByPosm {}

    function notifyUnsubscribe(uint256) external override onlyByPosm {}

    function notifyModifyLiquidity(uint256, int256, BalanceDelta) external override onlyByPosm {}

    function notifyBurn(uint256, address, PositionInfo, uint256, BalanceDelta) external override onlyByPosm {
        revert("notifyBurn");
    }
}

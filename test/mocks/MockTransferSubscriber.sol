// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ISubscriber} from "../../src/interfaces/ISubscriber.sol";
import {IPositionManager} from "../../src/interfaces/IPositionManager.sol";
import {BalanceDelta} from "@uniswap/v4-core/src/types/BalanceDelta.sol";
import {PositionInfo} from "../../src/libraries/PositionInfoLibrary.sol";

/// @notice Subscriber mock that tracks notifyTransfer calls
contract MockTransferSubscriber is ISubscriber {
    IPositionManager public posm;

    uint256 public notifySubscribeCount;
    uint256 public notifyUnsubscribeCount;
    uint256 public notifyModifyLiquidityCount;
    uint256 public notifyBurnCount;
    uint256 public notifyTransferCount;

    address public oldOwner;
    address public newOwner;

    int256 public liquidityChange;
    BalanceDelta public feesAccrued;

    bytes public subscribeData;

    error NotAuthorizedNotifier(address sender);

    constructor(IPositionManager _posm) {
        posm = _posm;
    }

    modifier onlyByPosm() {
        if (msg.sender != address(posm)) revert NotAuthorizedNotifier(msg.sender);
        _;
    }

    function notifySubscribe(uint256, bytes memory data) external onlyByPosm {
        notifySubscribeCount++;
        subscribeData = data;
    }

    function notifyUnsubscribe(uint256) external onlyByPosm {
        notifyUnsubscribeCount++;
    }

    function notifyModifyLiquidity(uint256, int256 _liquidityChange, BalanceDelta _feesAccrued) external onlyByPosm {
        notifyModifyLiquidityCount++;
        liquidityChange = _liquidityChange;
        feesAccrued = _feesAccrued;
    }

    function notifyBurn(uint256, address, PositionInfo, uint256, BalanceDelta) external onlyByPosm {
        notifyBurnCount++;
    }

    function notifyTransfer(uint256, address _oldOwner, address _newOwner) external onlyByPosm {
        notifyTransferCount++;
        oldOwner = _oldOwner;
        newOwner = _newOwner;
    }
}

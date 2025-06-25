// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Notifier} from "../../src/base/Notifier.sol";
import {ISubscriber} from "../../src/interfaces/ISubscriber.sol";
import {PositionInfo} from "../../src/libraries/PositionInfoLibrary.sol";
import {BalanceDelta} from "@uniswap/v4-core/src/types/BalanceDelta.sol";

/// @dev Minimal harness exposing Notifier internal functions for testing
contract NotifierHarness is Notifier {
    constructor(uint256 gasLimit) Notifier(gasLimit) {}

    modifier onlyIfApproved(address, uint256) override {
        _;
    }

    modifier onlyIfPoolManagerLocked() override {
        _;
    }

    uint256 public lastSubscribed;
    uint256 public lastUnsubscribed;

    function _setUnsubscribed(uint256 tokenId) internal override {
        lastUnsubscribed = tokenId;
    }

    function _setSubscribed(uint256 tokenId) internal override {
        lastSubscribed = tokenId;
    }

    function unsubscribeWrap(uint256 tokenId) external {
        _unsubscribe(tokenId);
    }

    function removeSubscriberAndNotifyBurn(
        uint256 tokenId,
        address owner,
        PositionInfo info,
        uint256 liquidity,
        BalanceDelta fees
    ) external {
        _removeSubscriberAndNotifyBurn(tokenId, owner, info, liquidity, fees);
    }

    function notifyModifyLiquidityWrap(uint256 tokenId, int256 liquidityChange, BalanceDelta feesAccrued) external {
        _notifyModifyLiquidity(tokenId, liquidityChange, feesAccrued);
    }

    function callWrap(address target, bytes calldata data) external returns (bool) {
        return _call(target, data);
    }
}

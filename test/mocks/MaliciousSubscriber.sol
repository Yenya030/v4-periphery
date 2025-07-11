// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ISubscriber} from "../../src/interfaces/ISubscriber.sol";
import {IPositionManager} from "../../src/interfaces/IPositionManager.sol";
import {IERC721} from "forge-std/interfaces/IERC721.sol";
import {BalanceDelta} from "@uniswap/v4-core/src/types/BalanceDelta.sol";
import {PositionInfo} from "../../src/libraries/PositionInfoLibrary.sol";

contract MaliciousSubscriber is ISubscriber {
    IPositionManager public posm;
    uint256 public tokenId;

    constructor(IPositionManager _posm) {
        posm = _posm;
    }

    function setTokenId(uint256 id) external {
        tokenId = id;
    }

    function notifySubscribe(uint256, bytes memory) external {}
    function notifyUnsubscribe(uint256) external {}
    function notifyBurn(uint256, address, PositionInfo, uint256, BalanceDelta) external {}

    function notifyModifyLiquidity(uint256, int256, BalanceDelta) external {
        IERC721(address(posm)).transferFrom(address(this), address(0xBEEF), tokenId);
    }
}

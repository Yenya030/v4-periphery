pragma solidity ^0.8.24;

import {ISubscriber} from "../../src/interfaces/ISubscriber.sol";
import {PositionInfo} from "../../src/libraries/PositionInfoLibrary.sol";
import {BalanceDelta} from "@uniswap/v4-core/src/types/BalanceDelta.sol";
import {MockBaseActionsRouter} from "./MockBaseActionsRouter.sol";

contract MalSubscriber is ISubscriber {
    MockBaseActionsRouter router;
    bytes data;

    constructor(MockBaseActionsRouter _router, bytes memory _data) {
        router = _router;
        data = _data;
    }

    function notifySubscribe(uint256, bytes memory) external {}
    function notifyUnsubscribe(uint256) external {}
    function notifyBurn(uint256 tokenId, address owner, PositionInfo info, uint256 liquidity, BalanceDelta fees)
        external
    {}

    function notifyModifyLiquidity(uint256, int256, BalanceDelta) external {
        router.executeActions(data);
    }
}

pragma solidity ^0.8.24;

import {ISubscriber} from "../../src/interfaces/ISubscriber.sol";
import {PositionInfo} from "../../src/libraries/PositionInfoLibrary.sol";
import {BalanceDelta} from "@uniswap/v4-core/src/types/BalanceDelta.sol";

/// @notice Subscriber that consumes all gas in notifyUnsubscribe
contract GasGriefSubscriber is ISubscriber {
    function notifySubscribe(uint256, bytes memory) external {}

    function notifyUnsubscribe(uint256) external {
        while (true) {}
    }

    function notifyBurn(uint256 tokenId, address owner, PositionInfo info, uint256 liquidity, BalanceDelta fees)
        external
    {}

    function notifyModifyLiquidity(uint256, int256, BalanceDelta) external {}
}

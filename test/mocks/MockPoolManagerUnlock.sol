pragma solidity ^0.8.24;

import {ISubscriber} from "../../src/interfaces/ISubscriber.sol";
import {BalanceDelta} from "@uniswap/v4-core/src/types/BalanceDelta.sol";

contract MockPoolManagerUnlock {
    bool public unlocked;
    ISubscriber public subscriber;

    function setSubscriber(ISubscriber sub) external {
        subscriber = sub;
    }

    function unlock(bytes calldata data) external returns (bytes memory) {
        require(!unlocked, "already unlocked");
        unlocked = true;
        if (address(subscriber) != address(0)) {
            subscriber.notifyModifyLiquidity(0, 0, BalanceDelta.wrap(0));
        }
        (bool ok, bytes memory ret) = msg.sender.call(abi.encodeWithSignature("unlockCallback(bytes)", data));
        unlocked = false;
        require(ok, "callback fail");
        return ret;
    }
}

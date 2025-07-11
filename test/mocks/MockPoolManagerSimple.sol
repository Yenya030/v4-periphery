// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {PoolKey} from "@uniswap/v4-core/src/types/PoolKey.sol";
import {Currency} from "@uniswap/v4-core/src/types/Currency.sol";
import {BalanceDelta, BalanceDeltaLibrary} from "@uniswap/v4-core/src/types/BalanceDelta.sol";
import {ModifyLiquidityParams, SwapParams} from "@uniswap/v4-core/src/types/PoolOperation.sol";
import {Lock} from "@uniswap/v4-core/src/libraries/Lock.sol";
import {IUnlockCallback} from "@uniswap/v4-core/src/interfaces/callback/IUnlockCallback.sol";

contract MockPoolManagerSimple {
    using BalanceDeltaLibrary for BalanceDelta;

    bool public unlocked;

    function unlock(bytes calldata data) external returns (bytes memory result) {
        require(!unlocked, "already unlocked");
        unlocked = true;
        result = IUnlockCallback(msg.sender).unlockCallback(data);
        unlocked = false;
    }

    function isUnlocked() external view returns (bool) {
        return unlocked;
    }

    function modifyLiquidity(PoolKey memory, ModifyLiquidityParams memory, bytes calldata)
        external
        returns (BalanceDelta callerDelta, BalanceDelta feesAccrued)
    {
        callerDelta = BalanceDelta.wrap(0);
        feesAccrued = BalanceDelta.wrap(0);
    }

    function initialize(PoolKey memory, uint160) external returns (int24) {
        return 0;
    }

    function swap(PoolKey memory, SwapParams memory, bytes calldata) external returns (BalanceDelta) {
        return BalanceDelta.wrap(0);
    }

    function donate(PoolKey memory, uint256, uint256, bytes calldata) external returns (BalanceDelta) {
        return BalanceDelta.wrap(0);
    }

    function sync(Currency) external {}

    function take(Currency, address, uint256) external {}

    function settle() external payable returns (uint256 paid) {
        paid = 0;
    }

    function settleFor(address) external payable returns (uint256 paid) {
        paid = 0;
    }

    function clear(Currency, uint256) external {}

    function mint(address, uint256, uint256) external {}

    function burn(address, uint256, uint256) external {}

    function updateDynamicLPFee(PoolKey memory, uint24) external {}

    function currencyDelta(address, Currency) external view returns (int256) {
        return 0;
    }

    function claim(address, address, uint256) external returns (uint256) {
        return 0;
    }

    function exttload(bytes32 slot) external view returns (bytes32 value) {
        if (slot == Lock.IS_UNLOCKED_SLOT) {
            value = unlocked ? bytes32(uint256(1)) : bytes32(0);
        }
    }
}

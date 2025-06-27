// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Currency} from "@uniswap/v4-core/src/types/Currency.sol";
import {IPoolManager} from "@uniswap/v4-core/src/interfaces/IPoolManager.sol";

contract MockPoolManagerClearOrTake {
    mapping(bytes32 => int256) public deltas;

    bool public clearCalled;
    Currency public lastClearCurrency;
    uint256 public lastClearAmount;

    bool public takeCalled;
    Currency public lastTakeCurrency;
    address public lastTakeRecipient;
    uint256 public lastTakeAmount;

    function setDelta(address owner, Currency currency, int256 delta) external {
        deltas[keccak256(abi.encode(owner, Currency.unwrap(currency)))] = delta;
    }

    function currencyDelta(address owner, Currency currency) external view returns (int256) {
        return deltas[keccak256(abi.encode(owner, Currency.unwrap(currency)))];
    }

    function exttload(bytes32 slot) external view returns (bytes32 value) {
        return bytes32(uint256(int256(deltas[slot])));
    }

    function sync(Currency) external {}
    function settle() external payable {}

    function clear(Currency currency, uint256 amount) external {
        clearCalled = true;
        lastClearCurrency = currency;
        lastClearAmount = amount;
    }

    function take(Currency currency, address to, uint256 amount) external {
        takeCalled = true;
        lastTakeCurrency = currency;
        lastTakeRecipient = to;
        lastTakeAmount = amount;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {WstETHHook} from "../../src/hooks/WstETHHook.sol";
import {IPoolManager} from "@uniswap/v4-core/src/interfaces/IPoolManager.sol";
import {IWstETH} from "../../src/interfaces/external/IWstETH.sol";

/// @dev Harness exposing internal view helpers for testing
contract WstETHHookHarness is WstETHHook {
    constructor(IWstETH _wsteth) WstETHHook(IPoolManager(address(0)), _wsteth) {}

    function wrapRequired(uint256 amount) external view returns (uint256) {
        return _getWrapInputRequired(amount);
    }

    function unwrapRequired(uint256 amount) external view returns (uint256) {
        return _getUnwrapInputRequired(amount);
    }
}

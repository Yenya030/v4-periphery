// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {WETHHook} from "../../src/hooks/WETHHook.sol";
import {IPoolManager} from "@uniswap/v4-core/src/interfaces/IPoolManager.sol";
import {WETH} from "solmate/src/tokens/WETH.sol";
import {BaseHook} from "../../src/utils/BaseHook.sol";

/// @dev Harness exposing internal view functions for testing
contract WETHHookHarness is WETHHook {
    constructor(IPoolManager _manager, WETH _weth) WETHHook(_manager, payable(address(_weth))) {}

    function validateHookAddress(BaseHook) internal pure override {}

    function supportsExactOutput() external view returns (bool) {
        return _supportsExactOutput();
    }

    function supportsExactInput() external view returns (bool) {
        return _supportsExactInput();
    }
}

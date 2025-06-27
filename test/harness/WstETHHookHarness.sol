pragma solidity ^0.8.24;

import {WstETHHook} from "../../src/hooks/WstETHHook.sol";
import {IPoolManager} from "@uniswap/v4-core/src/interfaces/IPoolManager.sol";
import {IWstETH} from "../../src/interfaces/external/IWstETH.sol";
import {BaseHook} from "../../src/utils/BaseHook.sol";

/// @dev Harness exposing internal view functions for testing
contract WstETHHookHarness is WstETHHook {
    constructor(IPoolManager _manager, IWstETH _wsteth) WstETHHook(_manager, _wsteth) {}

    function validateHookAddress(BaseHook) internal pure override {}

    function getWrapInputRequired(uint256 amount) external view returns (uint256) {
        return _getWrapInputRequired(amount);
    }

    function getUnwrapInputRequired(uint256 amount) external view returns (uint256) {
        return _getUnwrapInputRequired(amount);
    }

    function supportsExactOutput() external view returns (bool) {
        return _supportsExactOutput();
    }

    function supportsExactInput() external view returns (bool) {
        return _supportsExactInput();
    }
}

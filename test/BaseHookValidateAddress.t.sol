// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {BaseHook} from "../src/utils/BaseHook.sol";
import {Hooks} from "@uniswap/v4-core/src/libraries/Hooks.sol";
import {IPoolManager} from "@uniswap/v4-core/src/interfaces/IPoolManager.sol";
import {HookMiner} from "../src/utils/HookMiner.sol";

contract DummyPoolManager2 {}

contract BadHook is BaseHook {
    constructor(IPoolManager manager) BaseHook(manager) {}
    function getHookPermissions() public pure override returns (Hooks.Permissions memory perm) {
        perm = Hooks.Permissions({
            beforeInitialize: true,
            afterInitialize: false,
            beforeAddLiquidity: false,
            afterAddLiquidity: false,
            beforeRemoveLiquidity: false,
            afterRemoveLiquidity: false,
            beforeSwap: false,
            afterSwap: false,
            beforeDonate: false,
            afterDonate: false,
            beforeSwapReturnDelta: false,
            afterSwapReturnDelta: false,
            afterAddLiquidityReturnDelta: false,
            afterRemoveLiquidityReturnDelta: false
        });
    }
}

contract BaseHookValidateAddressTest is Test {
    function test_constructor_reverts_when_address_mismatch() public {
        DummyPoolManager2 pm = new DummyPoolManager2();
        bytes memory bytecode = abi.encodePacked(type(BadHook).creationCode, abi.encode(IPoolManager(address(pm))));
        uint160 flags = uint160(Hooks.BEFORE_INITIALIZE_FLAG);
        bytes32 salt = bytes32(uint256(1));
        address predicted = HookMiner.computeAddress(address(this), uint256(salt), bytecode);
        if ((uint160(predicted) & Hooks.ALL_HOOK_MASK) == flags) {
            salt = bytes32(uint256(2));
            predicted = HookMiner.computeAddress(address(this), uint256(salt), bytecode);
        }
        vm.expectRevert(abi.encodeWithSelector(Hooks.HookAddressNotValid.selector, predicted));
        new BadHook{salt: salt}(IPoolManager(address(pm)));
    }
}


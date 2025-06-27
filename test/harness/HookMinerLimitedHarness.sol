pragma solidity ^0.8.24;

import {HookMiner} from "../../src/utils/HookMiner.sol";
import {IPoolManager} from "@uniswap/v4-core/src/interfaces/IPoolManager.sol";

/// @notice Harness exposing a modified version of HookMiner.find with a configurable max loop
contract HookMinerLimitedHarness {
    function findLimited(
        address deployer,
        uint160 flags,
        bytes memory creationCode,
        bytes memory constructorArgs,
        uint256 maxLoop
    ) external view returns (address hookAddress, bytes32 salt) {
        flags = flags & HookMiner.FLAG_MASK;
        bytes memory creationCodeWithArgs = abi.encodePacked(creationCode, constructorArgs);
        for (uint256 i; i < maxLoop; i++) {
            hookAddress = HookMiner.computeAddress(deployer, i, creationCodeWithArgs);
            if (uint160(hookAddress) & HookMiner.FLAG_MASK == flags && hookAddress.code.length == 0) {
                return (hookAddress, bytes32(i));
            }
        }
        revert("HookMiner: could not find salt");
    }
}

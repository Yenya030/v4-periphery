// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {HookMiner} from "../../src/utils/HookMiner.sol";
import {MockBlankHook} from "../mocks/MockBlankHook.sol";
import {IPoolManager} from "@uniswap/v4-core/src/interfaces/IPoolManager.sol";

contract HookMinerDeterministicTest is Test {
    function test_computeAddress_deterministic() public {
        address deployer = address(0xabc);
        bytes memory init = abi.encodePacked(
            type(MockBlankHook).creationCode, abi.encode(IPoolManager(address(0)), uint256(1), uint16(0))
        );
        address a = HookMiner.computeAddress(deployer, 123, init);
        address b = HookMiner.computeAddress(deployer, 123, init);
        assertEq(a, b);
    }
}

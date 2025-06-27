// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {Create2} from "@openzeppelin/contracts/utils/Create2.sol";
import {HookMiner} from "../../src/utils/HookMiner.sol";
import {MockBlankHook} from "../mocks/MockBlankHook.sol";
import {IPoolManager} from "@uniswap/v4-core/src/interfaces/IPoolManager.sol";

contract HookMinerComputeAddressTest is Test {
    function test_computeAddress_matches_create2() public {
        address deployer = address(this);
        bytes memory bytecode = abi.encodePacked(
            type(MockBlankHook).creationCode, abi.encode(IPoolManager(address(0)), uint256(123), uint16(0))
        );
        uint256 salt = 12345;
        address expected = Create2.computeAddress(bytes32(salt), keccak256(bytecode), deployer);
        address result = HookMiner.computeAddress(deployer, salt, bytecode);
        assertEq(result, expected);
    }
}

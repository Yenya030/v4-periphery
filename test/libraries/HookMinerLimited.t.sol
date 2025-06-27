// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {HookMiner} from "../../src/utils/HookMiner.sol";
import {MockBlankHook} from "../mocks/MockBlankHook.sol";
import {HookMinerLimitedHarness} from "../harness/HookMinerLimitedHarness.sol";
import {IPoolManager} from "@uniswap/v4-core/src/interfaces/IPoolManager.sol";

contract HookMinerLimitedTest is Test {
    HookMinerLimitedHarness harness;

    function setUp() public {
        harness = new HookMinerLimitedHarness();
    }

    function test_findLimited_matches_library(uint16 flags, uint256 number) public {
        (address expectedAddr, bytes32 expectedSalt) = HookMiner.find(
            address(this),
            uint160(flags),
            type(MockBlankHook).creationCode,
            abi.encode(IPoolManager(address(0)), number, flags)
        );

        (address resultAddr, bytes32 resultSalt) = harness.findLimited(
            address(this),
            uint160(flags),
            type(MockBlankHook).creationCode,
            abi.encode(IPoolManager(address(0)), number, flags),
            uint256(uint256(expectedSalt) + 1)
        );

        assertEq(resultAddr, expectedAddr);
        assertEq(resultSalt, expectedSalt);
    }

    function test_findLimited_reverts_when_limit_too_small(uint16 flags, uint256 number) public {
        (address expectedAddr, bytes32 expectedSalt) = HookMiner.find(
            address(this),
            uint160(flags),
            type(MockBlankHook).creationCode,
            abi.encode(IPoolManager(address(0)), number, flags)
        );

        vm.expectRevert(bytes("HookMiner: could not find salt"));
        harness.findLimited(
            address(this),
            uint160(flags),
            type(MockBlankHook).creationCode,
            abi.encode(IPoolManager(address(0)), number, flags),
            uint256(uint256(expectedSalt))
        );

        // silence unused var warnings
        expectedAddr;
    }
}

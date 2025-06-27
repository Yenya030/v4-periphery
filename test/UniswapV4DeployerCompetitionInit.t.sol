// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {UniswapV4DeployerCompetition} from "../src/UniswapV4DeployerCompetition.sol";
import {PoolManager} from "@uniswap/v4-core/src/PoolManager.sol";

contract UniswapV4DeployerCompetitionInitTest is Test {
    UniswapV4DeployerCompetition competition;
    uint256 competitionDeadline;
    uint256 exclusiveDeployLength = 2 days;
    address deployer = address(0x1234);
    address owner = address(0x5678);

    function setUp() public {
        competitionDeadline = block.timestamp + 10 days;
        bytes32 initCodeHash = keccak256(abi.encodePacked(type(PoolManager).creationCode, uint256(uint160(owner))));
        competition = new UniswapV4DeployerCompetition(initCodeHash, competitionDeadline, deployer, exclusiveDeployLength);
    }

    function test_exclusiveDeployDeadline_calculation() public {
        assertEq(competition.exclusiveDeployDeadline(), competitionDeadline + exclusiveDeployLength);
        assertEq(competition.deployer(), deployer);
    }
}

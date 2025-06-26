// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {IHooks} from "@uniswap/v4-core/src/interfaces/IHooks.sol";
import {PoolKey} from "@uniswap/v4-core/src/types/PoolKey.sol";
import {PoolId} from "@uniswap/v4-core/src/types/PoolId.sol";
import {Currency} from "@uniswap/v4-core/src/types/Currency.sol";
import {PositionInfo} from "../../src/libraries/PositionInfoLibrary.sol";
import {PositionConfig} from "../shared/PositionConfig.sol";
import {PosmTestSetup} from "../shared/PosmTestSetup.sol";

contract GetPoolAndPositionInfoTest is Test, PosmTestSetup {
    PoolId poolId;

    function setUp() public {
        deployFreshManagerAndRouters();
        deployMintAndApprove2Currencies();
        (key, poolId) = initPool(currency0, currency1, IHooks(address(0)), 3000, SQRT_PRICE_1_1);
        deployAndApprovePosm(manager);
    }

    function test_getPoolAndPositionInfo_returns_pool_and_position() public {
        PositionConfig memory config = PositionConfig({poolKey: key, tickLower: -key.tickSpacing, tickUpper: key.tickSpacing});
        uint256 liquidity = 1e18;
        mint(config, liquidity, address(this), "");
        uint256 tokenId = lpm.nextTokenId() - 1;

        (PoolKey memory returnedKey, PositionInfo info) = lpm.getPoolAndPositionInfo(tokenId);

        assertEq(Currency.unwrap(returnedKey.currency0), Currency.unwrap(key.currency0));
        assertEq(Currency.unwrap(returnedKey.currency1), Currency.unwrap(key.currency1));
        assertEq(returnedKey.fee, key.fee);
        assertEq(returnedKey.tickSpacing, key.tickSpacing);
        assertEq(address(returnedKey.hooks), address(key.hooks));
        assertEq(info.tickLower(), config.tickLower);
        assertEq(info.tickUpper(), config.tickUpper);
        assertEq(bytes25(info.poolId()), bytes25(PoolId.unwrap(poolId)));

        uint128 returnedLiquidity = lpm.getPositionLiquidity(tokenId);
        assertEq(returnedLiquidity, liquidity);
    }
}


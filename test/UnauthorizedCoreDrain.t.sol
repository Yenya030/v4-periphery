// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {IPoolManager} from "@uniswap/v4-core/src/interfaces/IPoolManager.sol";
import {IHooks} from "@uniswap/v4-core/src/interfaces/IHooks.sol";
import {PoolKey} from "@uniswap/v4-core/src/types/PoolKey.sol";
import {ModifyLiquidityParams} from "@uniswap/v4-core/src/types/PoolOperation.sol";
import {Position} from "@uniswap/v4-core/src/libraries/Position.sol";
import {SafeCast} from "@uniswap/v4-core/src/libraries/SafeCast.sol";
import {PositionConfig} from "./shared/PositionConfig.sol";
import {PosmTestSetup} from "./shared/PosmTestSetup.sol";

contract UnauthorizedCoreDrainTest is Test, PosmTestSetup {
    address alice = makeAddr("ALICE");
    address bob = makeAddr("BOB");

    PositionConfig config;

    function setUp() public {
        deployFreshManagerAndRouters();
        deployMintAndApprove2Currencies();
        (key,) = initPool(currency0, currency1, IHooks(address(0)), 3000, SQRT_PRICE_1_1);
        deployAndApprovePosm(manager);
        seedBalance(alice);
        seedBalance(bob);
        approvePosmFor(alice);
        approvePosmFor(bob);
        config = PositionConfig({poolKey: key, tickLower: -300, tickUpper: 300});
    }

    function test_direct_core_call_reverts() public {
        uint256 liquidity = 1e18;
        vm.prank(alice);
        mint(config, liquidity, alice, "");
        uint256 tokenId = lpm.nextTokenId() - 1;

        ModifyLiquidityParams memory params = ModifyLiquidityParams({
            tickLower: config.tickLower,
            tickUpper: config.tickUpper,
            liquidityDelta: -int256(liquidity),
            salt: bytes32(tokenId)
        });

        vm.expectRevert(SafeCast.SafeCastOverflow.selector);
        vm.prank(bob);
        modifyLiquidityNoChecks.modifyLiquidity(key, params, "");
    }
}

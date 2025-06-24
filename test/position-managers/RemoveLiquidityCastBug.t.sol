// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {PoolKey} from "@uniswap/v4-core/src/types/PoolKey.sol";
import {IHooks} from "@uniswap/v4-core/src/interfaces/IHooks.sol";
import {PoolManager} from "@uniswap/v4-core/src/PoolManager.sol";
import {BalanceDelta} from "@uniswap/v4-core/src/types/BalanceDelta.sol";
import {TickMath} from "@uniswap/v4-core/src/libraries/TickMath.sol";
import {Constants} from "@uniswap/v4-core/test/utils/Constants.sol";

import {Hooks} from "@uniswap/v4-core/src/libraries/Hooks.sol";
import {SlippageCheck} from "../../src/libraries/SlippageCheck.sol";
import {SafeCast} from "@uniswap/v4-core/src/libraries/SafeCast.sol";
import {PositionConfig} from "../shared/PositionConfig.sol";
import {PosmTestSetup} from "../shared/PosmTestSetup.sol";
import {NegativeDeltaHook} from "../mocks/NegativeDeltaHook.sol";
import {Actions} from "../../src/libraries/Actions.sol";
import {Planner, Plan} from "../shared/Planner.sol";

contract RemoveLiquidityCastBugTest is Test, PosmTestSetup {
    NegativeDeltaHook negHook;
    PositionConfig config;

    function setUp() public {
        deployFreshManagerAndRouters();
        deployMintAndApprove2Currencies();

        // deploy hook implementation and copy code to address with required flags
        negHook = new NegativeDeltaHook();
        hookAddr = address(
            uint160(
                type(uint160).max & clearAllHookPermissionsMask | Hooks.AFTER_REMOVE_LIQUIDITY_FLAG
                    | Hooks.AFTER_REMOVE_LIQUIDITY_RETURNS_DELTA_FLAG
            )
        );
        vm.etch(hookAddr, address(negHook).code);
        negHook = NegativeDeltaHook(hookAddr);

        (key,) = initPool(currency0, currency1, IHooks(hookAddr), 3000, Constants.SQRT_PRICE_1_1);
        deployAndApprovePosm(manager);
        seedBalance(address(this));
        approvePosm();
        config = PositionConfig({poolKey: key, tickLower: -120, tickUpper: 120});
    }

    function test_fuzz_negative_delta_remove(uint128 liquidity, int128 delta) public {
        liquidity = uint128(bound(liquidity, 1e6, 1e18));
        int256 maxMagnitude = int256(type(int128).max) - int256(uint256(liquidity)) - 1;
        int128 magnitude = int128(bound(int256(delta), 1, maxMagnitude));
        int256 total = int256(uint256(liquidity)) + int256(magnitude);
        negHook.setDelta(-int128(total));
        uint256 tokenId = lpm.nextTokenId();
        mint(config, liquidity, address(this), Constants.ZERO_BYTES);

        Plan memory planner = Planner.init();
        planner.add(
            Actions.DECREASE_LIQUIDITY,
            abi.encode(tokenId, liquidity, type(uint128).max, type(uint128).max, Constants.ZERO_BYTES)
        );
        bytes memory calls = planner.finalizeModifyLiquidityWithClose(config.poolKey);

        vm.expectRevert();
        lpm.modifyLiquidities(calls, _deadline);
    }
}

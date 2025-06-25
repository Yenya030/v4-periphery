// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {IHooks} from "@uniswap/v4-core/src/interfaces/IHooks.sol";
import {Hooks} from "@uniswap/v4-core/src/libraries/Hooks.sol";
import {Constants} from "@uniswap/v4-core/test/utils/Constants.sol";
import {PosmTestSetup} from "./shared/PosmTestSetup.sol";
import {PositionConfig} from "./shared/PositionConfig.sol";
import {NegativeDeltaHook} from "./mocks/NegativeDeltaHook.sol";
import {Planner, Plan} from "./shared/Planner.sol";
import {Actions} from "../src/libraries/Actions.sol";
import {SlippageCheck} from "../src/libraries/SlippageCheck.sol";
import {BalanceDelta, toBalanceDelta} from "../lib/v4-core/src/types/BalanceDelta.sol";

contract NegativeDeltaRemoveTest is Test, PosmTestSetup {
    NegativeDeltaHook negHook;
    PositionConfig config;

    function setUp() public {
        deployFreshManagerAndRouters();
        deployMintAndApprove2Currencies();

        negHook = new NegativeDeltaHook();
        hookAddr = address(
            uint160(
                type(uint160).max & clearAllHookPermissionsMask
                    | Hooks.AFTER_REMOVE_LIQUIDITY_FLAG
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
        int256 maxMag = int256(type(int128).max) - int256(uint256(liquidity)) - 1;
        int128 magnitude = int128(bound(int256(delta), 1, maxMag));
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

contract PositiveDeltaLibraryTest is Test {
    SlippageHarness harness;

    function setUp() public {
        harness = new SlippageHarness();
    }

    function test_validateMaxIn_positiveDelta() public {
        BalanceDelta delta = toBalanceDelta(5, 3);
        harness.callValidateMaxIn(delta, 1, 1);
    }
}

contract SlippageHarness {
    function callValidateMaxIn(BalanceDelta delta, uint128 max0, uint128 max1) external pure {
        SlippageCheck.validateMaxIn(delta, max0, max1);
    }
}

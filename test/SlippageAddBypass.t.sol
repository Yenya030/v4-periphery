// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {IHooks} from "@uniswap/v4-core/src/interfaces/IHooks.sol";
import {TickMath} from "@uniswap/v4-core/src/libraries/TickMath.sol";
import {LiquidityAmounts} from "@uniswap/v4-core/test/utils/LiquidityAmounts.sol";

import {PosmTestSetup} from "./shared/PosmTestSetup.sol";
import {PositionConfig} from "./shared/PositionConfig.sol";
import {ActionConstants} from "../src/libraries/ActionConstants.sol";
import {Actions} from "../src/libraries/Actions.sol";
import {Planner} from "./shared/Planner.sol";
import {SlippageCheck} from "../src/libraries/SlippageCheck.sol";

contract SlippageAddBypassTest is Test, PosmTestSetup {
    PositionConfig config;

    function setUp() public {
        deployFreshManagerAndRouters();
        deployMintAndApprove2Currencies();
        deployPosmHookSavesDelta();

        (key,) = initPool(currency0, currency1, IHooks(hook), 3000, SQRT_PRICE_1_1);

        deployAndApprovePosm(manager);
        seedBalance(address(this));
        approvePosm();

        config = PositionConfig({poolKey: key, tickLower: -120, tickUpper: 120});
    }

    function test_feesExceedDeposit_slippageStillChecked() public {
        uint256 tokenId = lpm.nextTokenId();
        mint(config, 100e18, ActionConstants.MSG_SENDER, ZERO_BYTES);

        uint256 donateAmount = 20e18;
        donateRouter.donate(key, donateAmount, donateAmount, ZERO_BYTES);

        uint128 newLiquidity = 10e18;
        (uint256 amount0,) = LiquidityAmounts.getAmountsForLiquidity(
            SQRT_PRICE_1_1,
            TickMath.getSqrtPriceAtTick(config.tickLower),
            TickMath.getSqrtPriceAtTick(config.tickUpper),
            newLiquidity
        );

        bytes memory calls = getIncreaseEncoded(tokenId, config, newLiquidity, 1 wei, 1 wei, ZERO_BYTES);
        vm.expectRevert(
            abi.encodeWithSelector(SlippageCheck.MaximumAmountExceeded.selector, 1 wei, amount0 + 1)
        );
        lpm.modifyLiquidities(calls, _deadline);
    }
}


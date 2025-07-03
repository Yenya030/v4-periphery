// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {IHooks} from "@uniswap/v4-core/src/interfaces/IHooks.sol";
import {Currency, CurrencyLibrary} from "@uniswap/v4-core/src/types/Currency.sol";
import {PositionConfig} from "../shared/PositionConfig.sol";
import {PosmTestSetup} from "../shared/PosmTestSetup.sol";
import {MockSubscriber} from "../mocks/MockSubscriber.sol";
import {IERC721} from "forge-std/interfaces/IERC721.sol";
import {LiquidityAmounts} from "@uniswap/v4-core/test/utils/LiquidityAmounts.sol";
import {TickMath} from "@uniswap/v4-core/src/libraries/TickMath.sol";

contract NotifierNativeTest is Test, PosmTestSetup {
    MockSubscriber sub;
    PositionConfig config;

    function setUp() public {
        deployFreshManagerAndRouters();
        deployMintAndApprove2Currencies();
        deployPosm(manager);
        // use native token as currency0
        currency0 = CurrencyLibrary.ADDRESS_ZERO;
        (nativeKey,) = initPool(currency0, currency1, IHooks(hook), 3000, SQRT_PRICE_1_1);
        approvePosmCurrency(currency1);
        sub = new MockSubscriber(lpm);
        vm.deal(address(this), type(uint256).max);
    }

    function test_subscribe_modify_unsubscribe_native() public {
        uint256 tokenId = lpm.nextTokenId();
        config = PositionConfig({poolKey: nativeKey, tickLower: -60, tickUpper: 60});
        mintWithNative(SQRT_PRICE_1_1, config, 1e18, address(this), "");
        // approve for notifier actions
        IERC721(address(lpm)).approve(address(this), tokenId);
        lpm.subscribe(tokenId, address(sub), "");
        (uint256 amount0,) = LiquidityAmounts.getAmountsForLiquidity(
            SQRT_PRICE_1_1,
            TickMath.getSqrtPriceAtTick(config.tickLower),
            TickMath.getSqrtPriceAtTick(config.tickUpper),
            1e18
        );
        bytes memory calls = getIncreaseEncoded(tokenId, config, 1e18, "");
        lpm.modifyLiquidities{value: amount0 + 1 wei}(calls, _deadline);
        assertEq(sub.notifyModifyLiquidityCount(), 1);
        lpm.unsubscribe(tokenId);
        assertEq(sub.notifyUnsubscribeCount(), 1);
        assertEq(lpm.positionInfo(tokenId).hasSubscriber(), false);
    }
}

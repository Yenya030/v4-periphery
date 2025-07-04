// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {PoolKey} from "@uniswap/v4-core/src/types/PoolKey.sol";
import {Currency} from "@uniswap/v4-core/src/types/Currency.sol";
import {IHooks} from "@uniswap/v4-core/src/interfaces/IHooks.sol";
import {Deployers} from "@uniswap/v4-core/test/utils/Deployers.sol";
import {Hooks} from "@uniswap/v4-core/src/libraries/Hooks.sol";
import {TickMath} from "@uniswap/v4-core/src/libraries/TickMath.sol";

import {WstETHHookHarness} from "../harness/WstETHHookHarness.sol";
import {MockWstETH} from "../mocks/MockWstETH.sol";
import {MockERC20} from "solmate/src/test/utils/mocks/MockERC20.sol";
import {TestRouter} from "../shared/TestRouter.sol";
import {SwapParams} from "@uniswap/v4-core/src/types/PoolOperation.sol";

contract WstETHHookRoundingTest is Test, Deployers {
    WstETHHookHarness hook;
    MockWstETH wstETH;
    MockERC20 stETH;
    TestRouter router;
    PoolKey poolKey;
    uint160 initPrice;
    address alice = makeAddr("alice");

    function setUp() public {
        deployFreshManagerAndRouters();
        router = new TestRouter(manager);
        stETH = new MockERC20("stETH", "STETH", 18);
        wstETH = new MockWstETH(address(stETH));
        hook = WstETHHookHarness(
            payable(
                address(
                    uint160(
                        type(uint160).max & clearAllHookPermissionsMask | Hooks.BEFORE_SWAP_FLAG
                            | Hooks.BEFORE_ADD_LIQUIDITY_FLAG | Hooks.BEFORE_SWAP_RETURNS_DELTA_FLAG
                            | Hooks.BEFORE_INITIALIZE_FLAG
                    )
                )
            )
        );
        deployCodeTo("WstETHHookHarness", abi.encode(manager, wstETH), address(hook));
        poolKey = PoolKey({
            currency0: Currency.wrap(address(stETH)),
            currency1: Currency.wrap(address(wstETH)),
            fee: 0,
            tickSpacing: 60,
            hooks: IHooks(address(hook))
        });
        initPrice = uint160(TickMath.getSqrtPriceAtTick(0));
        manager.initialize(poolKey, initPrice);
        stETH.mint(alice, 1); // 1 wei
    }

    function test_rounding_wrap_zero_out() public {
        vm.startPrank(alice);
        stETH.approve(address(router), 1);
        router.swap(
            poolKey,
            SwapParams({zeroForOne: true, amountSpecified: -int256(1), sqrtPriceLimitX96: TickMath.MIN_SQRT_PRICE + 1}),
            ""
        );
        vm.stopPrank();
        assertEq(stETH.balanceOf(alice), 0);
        assertEq(wstETH.balanceOf(alice), 0);
    }
}

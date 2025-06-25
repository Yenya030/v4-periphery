// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {IHooks} from "@uniswap/v4-core/src/interfaces/IHooks.sol";
import {BalanceDelta} from "@uniswap/v4-core/src/types/BalanceDelta.sol";
import {IPositionManager} from "../src/interfaces/IPositionManager.sol";

import {PosmTestSetup} from "./shared/PosmTestSetup.sol";
import {PositionConfig} from "./shared/PositionConfig.sol";
import {FeeMath} from "./shared/FeeMath.sol";

contract SlippageFeeAccrualTest is Test, PosmTestSetup {
    using FeeMath for IPositionManager;

    address alice = makeAddr("ALICE");
    PositionConfig config;

    function setUp() public {
        deployFreshManagerAndRouters();
        deployMintAndApprove2Currencies();
        deployPosmHookSavesDelta();

        (key,) = initPool(currency0, currency1, IHooks(hook), 3000, SQRT_PRICE_1_1);

        deployAndApprovePosm(manager);
        seedBalance(alice);
        approvePosmFor(alice);

        config = PositionConfig({poolKey: key, tickLower: -120, tickUpper: 120});
    }

    function test_fuzz_collect_zeroLiquidity_noRevert(uint128 donate0, uint128 donate1) public {
        donate0 = uint128(bound(donate0, 1, 1e18));
        donate1 = uint128(bound(donate1, 1, 1e18));

        vm.startPrank(alice);
        uint256 tokenId = lpm.nextTokenId();
        mint(config, 100e18, alice, ZERO_BYTES);
        vm.stopPrank();

        donateRouter.donate(key, donate0, donate1, ZERO_BYTES);

        BalanceDelta expected = IPositionManager(lpm).getFeesOwed(manager, config, tokenId);

        vm.prank(alice);
        decreaseLiquidity(tokenId, config, 0, ZERO_BYTES);
        BalanceDelta delta = getLastDelta();

        assertEq(delta.amount0(), expected.amount0(), "fee0 mismatch");
        assertEq(delta.amount1(), expected.amount1(), "fee1 mismatch");
    }
}

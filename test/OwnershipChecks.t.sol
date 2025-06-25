pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {IHooks} from "@uniswap/v4-core/src/interfaces/IHooks.sol";
import {IPositionManager} from "../src/interfaces/IPositionManager.sol";
import {PosmTestSetup} from "./shared/PosmTestSetup.sol";
import {PositionConfig} from "./shared/PositionConfig.sol";
import {Planner, Plan} from "./shared/Planner.sol";
import {Actions} from "../src/libraries/Actions.sol";

contract OwnershipChecksTest is Test, PosmTestSetup {
    address alice = makeAddr("ALICE");
    address bob = makeAddr("BOB");

    PositionConfig config;
    uint256 tokenId;

    function setUp() public {
        deployFreshManagerAndRouters();
        deployMintAndApprove2Currencies();
        (key,) = initPool(currency0, currency1, IHooks(address(0)), 3000, SQRT_PRICE_1_1);
        deployAndApprovePosm(manager);
        seedBalance(alice);
        approvePosmFor(alice);

        config = PositionConfig({poolKey: key, tickLower: -300, tickUpper: 300});

        vm.startPrank(alice);
        mint(config, 100e18, alice, "");
        vm.stopPrank();

        tokenId = lpm.nextTokenId() - 1;
    }

    function test_increaseLiquidity_unapproved_reverts() public {
        bytes memory calls = getIncreaseEncoded(tokenId, config, 1e18, "");
        vm.expectRevert(abi.encodeWithSelector(IPositionManager.NotApproved.selector, bob));
        vm.prank(bob);
        lpm.modifyLiquidities(calls, _deadline);
    }

    function test_decreaseLiquidity_unapproved_reverts() public {
        bytes memory calls = getDecreaseEncoded(tokenId, config, 1e18, "");
        vm.expectRevert(abi.encodeWithSelector(IPositionManager.NotApproved.selector, bob));
        vm.prank(bob);
        lpm.modifyLiquidities(calls, _deadline);
    }

    function test_collectFees_unapproved_reverts() public {
        donateRouter.donate(key, 1e18, 1e18, "");
        bytes memory calls = getCollectEncoded(tokenId, config, "");
        vm.expectRevert(abi.encodeWithSelector(IPositionManager.NotApproved.selector, bob));
        vm.prank(bob);
        lpm.modifyLiquidities(calls, _deadline);
    }

    function test_burn_unapproved_reverts() public {
        bytes memory calls = getBurnEncoded(tokenId, config, "");
        vm.expectRevert(abi.encodeWithSelector(IPositionManager.NotApproved.selector, bob));
        vm.prank(bob);
        lpm.modifyLiquidities(calls, _deadline);
    }

    function test_modifyLiquiditiesWithoutUnlock_unapproved_reverts() public {
        Plan memory planner = Planner.init();
        planner = planner.add(
            Actions.INCREASE_LIQUIDITY, abi.encode(tokenId, 1e18, MAX_SLIPPAGE_INCREASE, MAX_SLIPPAGE_INCREASE, "")
        );
        vm.expectRevert(abi.encodeWithSelector(IPositionManager.NotApproved.selector, bob));
        vm.prank(bob);
        lpm.modifyLiquiditiesWithoutUnlock(planner.actions, planner.params);
    }
}

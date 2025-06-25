// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {IERC721} from "forge-std/interfaces/IERC721.sol";
import {IHooks} from "@uniswap/v4-core/src/interfaces/IHooks.sol";
import {BalanceDelta} from "@uniswap/v4-core/src/types/BalanceDelta.sol";
import {CustomRevert} from "@uniswap/v4-core/src/libraries/CustomRevert.sol";

import {PosmTestSetup} from "./shared/PosmTestSetup.sol";
import {PositionConfig} from "./shared/PositionConfig.sol";
import {ISubscriber} from "../src/interfaces/ISubscriber.sol";
import {INotifier} from "../src/interfaces/INotifier.sol";
import {PositionInfo} from "../src/libraries/PositionInfoLibrary.sol";

contract EvilSubscriber is ISubscriber {
    function notifySubscribe(uint256, bytes memory) external {}
    function notifyUnsubscribe(uint256) external {}
    function notifyModifyLiquidity(uint256, int256, BalanceDelta) external {}

    function notifyBurn(uint256, address, PositionInfo, uint256, BalanceDelta) external pure {
        revert("boom");
    }
}

contract GasOrRevertSubscriber is ISubscriber {
    bytes32 public reason;
    bool public loop;

    function set(bytes32 _reason, bool _loop) external {
        reason = _reason;
        loop = _loop;
    }

    function notifySubscribe(uint256, bytes memory) external {}
    function notifyUnsubscribe(uint256) external {}
    function notifyModifyLiquidity(uint256, int256, BalanceDelta) external {}

    function notifyBurn(uint256, address, PositionInfo, uint256, BalanceDelta) external view {
        if (loop) {
            while (true) {}
        }
        revert(string(abi.encodePacked(reason)));
    }
}

contract SubscriberBurnDoSTest is Test, PosmTestSetup {
    EvilSubscriber evil;
    GasOrRevertSubscriber fuzzy;
    PositionConfig config;
    address alice = makeAddr("ALICE");

    function setUp() public {
        deployFreshManagerAndRouters();
        deployMintAndApprove2Currencies();
        (key,) = initPool(currency0, currency1, IHooks(address(0)), 3000, SQRT_PRICE_1_1);
        deployAndApprovePosm(manager);
        evil = new EvilSubscriber();
        fuzzy = new GasOrRevertSubscriber();
        config = PositionConfig({poolKey: key, tickLower: -300, tickUpper: 300});
    }

    function test_burn_reverts_when_notifyBurn_reverts() public {
        uint256 tokenId = lpm.nextTokenId();
        mint(config, 100e18, alice, "");

        vm.startPrank(alice);
        IERC721(address(lpm)).approve(address(this), tokenId);
        vm.stopPrank();

        lpm.subscribe(tokenId, address(evil), "");

        vm.expectRevert(
            abi.encodeWithSelector(
                CustomRevert.WrappedError.selector,
                address(evil),
                ISubscriber.notifyBurn.selector,
                abi.encodeWithSignature("Error(string)", "boom"),
                abi.encodeWithSelector(INotifier.BurnNotificationReverted.selector)
            )
        );
        burn(tokenId, config, "");
        assertEq(address(lpm.subscriber(tokenId)), address(evil));
    }

    function test_burn_succeeds_after_unsubscribe() public {
        uint256 tokenId = lpm.nextTokenId();
        mint(config, 100e18, alice, "");

        vm.startPrank(alice);
        IERC721(address(lpm)).approve(address(this), tokenId);
        vm.stopPrank();

        lpm.subscribe(tokenId, address(evil), "");
        vm.expectRevert(
            abi.encodeWithSelector(
                CustomRevert.WrappedError.selector,
                address(evil),
                ISubscriber.notifyBurn.selector,
                abi.encodeWithSignature("Error(string)", "boom"),
                abi.encodeWithSelector(INotifier.BurnNotificationReverted.selector)
            )
        );
        burn(tokenId, config, "");

        lpm.unsubscribe(tokenId);
        burn(tokenId, config, "");
        assertEq(lpm.positionInfo(tokenId).hasSubscriber(), false);
    }

    function test_fuzz_burn_with_misbehaving_subscriber(bytes32 reason) public {
        uint256 tokenId = lpm.nextTokenId();
        mint(config, 1e18, alice, "");

        vm.startPrank(alice);
        IERC721(address(lpm)).approve(address(this), tokenId);
        vm.stopPrank();

        lpm.subscribe(tokenId, address(fuzzy), "");
        fuzzy.set(reason, false);

        vm.expectRevert();
        burn(tokenId, config, "");

        lpm.unsubscribe(tokenId);
        burn(tokenId, config, "");
    }

    function test_burn_out_of_gas_subscriber() public {
        uint256 tokenId = lpm.nextTokenId();
        mint(config, 1e18, alice, "");

        vm.startPrank(alice);
        IERC721(address(lpm)).approve(address(this), tokenId);
        vm.stopPrank();

        lpm.subscribe(tokenId, address(fuzzy), "");
        fuzzy.set(bytes32("gas"), true);

        vm.expectRevert();
        burn(tokenId, config, "");

        lpm.unsubscribe(tokenId);
        burn(tokenId, config, "");
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {IERC721} from "forge-std/interfaces/IERC721.sol";
import {IHooks} from "@uniswap/v4-core/src/interfaces/IHooks.sol";

import {PosmTestSetup} from "./shared/PosmTestSetup.sol";
import {PositionConfig} from "./shared/PositionConfig.sol";
import {MockTransferSubscriber} from "./mocks/MockTransferSubscriber.sol";
import {IPositionManager} from "../../src/interfaces/IPositionManager.sol";

contract StaleSubscriberTest is Test, PosmTestSetup {
    MockTransferSubscriber sub;
    PositionConfig config;

    address alice = makeAddr("ALICE");
    address bob = makeAddr("BOB");

    function setUp() public {
        deployFreshManagerAndRouters();
        deployMintAndApprove2Currencies();

        (key,) = initPool(currency0, currency1, IHooks(address(0)), 3000, SQRT_PRICE_1_1);

        deployAndApprovePosm(manager);

        sub = new MockTransferSubscriber(lpm);

        config = PositionConfig({poolKey: key, tickLower: -300, tickUpper: 300});
    }

    function test_safeTransfer_keepsSubscriber() public {
        uint256 tokenId = lpm.nextTokenId();
        mint(config, 100e18, alice, ZERO_BYTES);

        vm.startPrank(alice);
        IERC721(address(lpm)).approve(address(this), tokenId);
        vm.stopPrank();

        lpm.subscribe(tokenId, address(sub), ZERO_BYTES);

        IERC721(address(lpm)).safeTransferFrom(alice, bob, tokenId);

        assertEq(sub.notifyTransferCount(), 0);
        assertEq(address(lpm.subscriber(tokenId)), address(sub));
    }

    function test_transferFrom_keepsSubscriber() public {
        uint256 tokenId = lpm.nextTokenId();
        mint(config, 100e18, alice, ZERO_BYTES);

        vm.startPrank(alice);
        IERC721(address(lpm)).approve(address(this), tokenId);
        vm.stopPrank();

        lpm.subscribe(tokenId, address(sub), ZERO_BYTES);

        IERC721(address(lpm)).transferFrom(alice, bob, tokenId);

        assertEq(sub.notifyTransferCount(), 0);
        assertEq(address(lpm.subscriber(tokenId)), address(sub));
    }
}

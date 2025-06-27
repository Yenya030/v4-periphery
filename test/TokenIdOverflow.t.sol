// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {stdStorage, StdStorage} from "forge-std/Test.sol";
import {IHooks} from "@uniswap/v4-core/src/interfaces/IHooks.sol";
import {IERC721} from "forge-std/interfaces/IERC721.sol";
import {PosmTestSetup} from "./shared/PosmTestSetup.sol";
import {PositionConfig} from "./shared/PositionConfig.sol";

contract TokenIdOverflowTest is Test, PosmTestSetup {
    using stdStorage for StdStorage;

    StdStorage store;
    PositionConfig config;
    address alice = makeAddr("ALICE");

    function setUp() public {
        deployFreshManagerAndRouters();
        deployMintAndApprove2Currencies();
        (key,) = initPool(currency0, currency1, IHooks(address(0)), 3000, SQRT_PRICE_1_1);
        deployAndApprovePosm(manager);
        seedBalance(alice);
        approvePosmFor(alice);
        config = PositionConfig({poolKey: key, tickLower: -300, tickUpper: 300});
    }

    function testOverflowNextTokenId() public {
        // Force nextTokenId to max uint256
        store.target(address(lpm)).sig("nextTokenId()").checked_write(type(uint256).max);

        // First mint causes nextTokenId to wrap to zero
        vm.startPrank(alice);
        mint(config, 1e18, alice, "");
        vm.stopPrank();

        // Next mint should reuse tokenId 0 due to overflow
        vm.startPrank(alice);
        mint(config, 1e18, alice, "");
        vm.stopPrank();

        assertEq(lpm.nextTokenId(), 1);
        assertEq(IERC721(address(lpm)).ownerOf(0), alice);
    }
}

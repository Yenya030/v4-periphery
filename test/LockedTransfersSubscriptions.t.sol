// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {IHooks} from "@uniswap/v4-core/src/interfaces/IHooks.sol";
import {IPositionManager} from "../src/interfaces/IPositionManager.sol";
import {IERC721} from "forge-std/interfaces/IERC721.sol";
import {IPoolManager} from "@uniswap/v4-core/src/interfaces/IPoolManager.sol";
import {IUnlockCallback} from "@uniswap/v4-core/src/interfaces/callback/IUnlockCallback.sol";

import {PosmTestSetup} from "./shared/PosmTestSetup.sol";
import {PositionConfig} from "./shared/PositionConfig.sol";

contract LockedTransfersSubscriptionsTest is Test, PosmTestSetup, IUnlockCallback {
    PositionConfig config;
    address alice = makeAddr("ALICE");
    address bob = makeAddr("BOB");
    address sub = makeAddr("SUBSCRIBER");

    function setUp() public {
        deployFreshManagerAndRouters();
        deployMintAndApprove2Currencies();

        (key,) = initPool(currency0, currency1, IHooks(hook), 3000, SQRT_PRICE_1_1);

        deployAndApprovePosm(manager);

        config = PositionConfig({poolKey: key, tickLower: -300, tickUpper: 300});

        seedBalance(alice);
        approvePosmFor(alice);

        vm.prank(alice);
        mint(config, 10e18, alice, ZERO_BYTES);
    }

    enum Action {
        TransferFrom,
        SafeTransferFrom,
        Subscribe,
        Unsubscribe
    }

    function tokenId() internal view returns (uint256) {
        return lpm.nextTokenId() - 1;
    }

    function unlockCallback(bytes calldata data) external override returns (bytes memory) {
        (Action action, address addr) = abi.decode(data, (Action, address));
        uint256 id = tokenId();
        if (action == Action.TransferFrom) {
            IERC721(address(lpm)).transferFrom(alice, addr, id);
        } else if (action == Action.SafeTransferFrom) {
            IERC721(address(lpm)).safeTransferFrom(alice, addr, id);
        } else if (action == Action.Subscribe) {
            lpm.subscribe(id, addr, "");
        } else if (action == Action.Unsubscribe) {
            lpm.unsubscribe(id);
        }
        return "";
    }

    function test_transferFrom_reverts_PoolManagerMustBeLocked() public {
        vm.expectRevert(IPositionManager.PoolManagerMustBeLocked.selector);
        manager.unlock(abi.encode(Action.TransferFrom, bob));
    }

    function test_safeTransferFrom_reverts_PoolManagerMustBeLocked() public {
        vm.expectRevert(IPositionManager.PoolManagerMustBeLocked.selector);
        manager.unlock(abi.encode(Action.SafeTransferFrom, bob));
    }

    function test_subscribe_reverts_PoolManagerMustBeLocked() public {
        vm.expectRevert(IPositionManager.PoolManagerMustBeLocked.selector);
        manager.unlock(abi.encode(Action.Subscribe, sub));
    }

    function test_unsubscribe_reverts_PoolManagerMustBeLocked() public {
        vm.expectRevert(IPositionManager.PoolManagerMustBeLocked.selector);
        manager.unlock(abi.encode(Action.Unsubscribe, address(0)));
    }

    function test_fuzz_lockedReverts(address to, address subscriber) public {
        to = address(uint160(to));
        subscriber = address(uint160(subscriber));
        vm.expectRevert(IPositionManager.PoolManagerMustBeLocked.selector);
        manager.unlock(abi.encode(Action.TransferFrom, to));

        vm.expectRevert(IPositionManager.PoolManagerMustBeLocked.selector);
        manager.unlock(abi.encode(Action.SafeTransferFrom, to));

        vm.expectRevert(IPositionManager.PoolManagerMustBeLocked.selector);
        manager.unlock(abi.encode(Action.Subscribe, subscriber));

        vm.expectRevert(IPositionManager.PoolManagerMustBeLocked.selector);
        manager.unlock(abi.encode(Action.Unsubscribe, address(0)));
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {IHooks} from "@uniswap/v4-core/src/interfaces/IHooks.sol";
import {IPoolManager} from "@uniswap/v4-core/src/interfaces/IPoolManager.sol";
import {Currency} from "@uniswap/v4-core/src/types/Currency.sol";

import {PosmTestSetup} from "./shared/PosmTestSetup.sol";
import {PositionConfig} from "./shared/PositionConfig.sol";
import {ISubscriber} from "../src/interfaces/ISubscriber.sol";
import {PositionInfo} from "../src/libraries/PositionInfoLibrary.sol";
import {BalanceDelta} from "@uniswap/v4-core/src/types/BalanceDelta.sol";

contract RobbingSubscriber is ISubscriber {
    IPoolManager public manager;
    Currency public currency;
    address public thief;

    constructor(IPoolManager _manager, Currency _currency, address _thief) {
        manager = _manager;
        currency = _currency;
        thief = _thief;
    }

    function notifySubscribe(uint256, bytes memory) external {}
    function notifyUnsubscribe(uint256) external {}
    function notifyBurn(uint256, address, PositionInfo, uint256, BalanceDelta) external {}

    function notifyModifyLiquidity(uint256, int256, BalanceDelta) external {
        // attempt to steal credit by taking during callback
        manager.take(currency, thief, 1);
    }
}

contract StealCreditTest is Test, PosmTestSetup {
    RobbingSubscriber sub;
    PositionConfig config;
    address thief = address(0xBEEF);

    function setUp() public {
        deployFreshManagerAndRouters();
        deployMintAndApprove2Currencies();
        (key,) = initPool(currency0, currency1, IHooks(address(0)), 3000, SQRT_PRICE_1_1);
        deployAndApprovePosm(manager);
        sub = new RobbingSubscriber(manager, currency0, thief);
        config = PositionConfig({poolKey: key, tickLower: -300, tickUpper: 300});
    }

    function test_steal_credit_fails() public {
        uint256 tokenId = lpm.nextTokenId();
        mint(config, 10e18, address(this), "");
        lpm.subscribe(tokenId, address(sub), "");
        vm.expectRevert();
        decreaseLiquidity(tokenId, config, 1e18, "");
    }
}

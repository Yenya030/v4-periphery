// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {Currency, CurrencyLibrary} from "@uniswap/v4-core/src/types/Currency.sol";
import {PoolKey} from "@uniswap/v4-core/src/types/PoolKey.sol";
import {MockERC20} from "solmate/src/test/utils/mocks/MockERC20.sol";
import {IHooks} from "@uniswap/v4-core/src/interfaces/IHooks.sol";
import {Deployers} from "@uniswap/v4-core/test/utils/Deployers.sol";

contract EthOrderingBugTest is Test, Deployers {
    function test_eth_as_currency1_reverts_initialize() public {
        deployFreshManager();
        Currency token = Currency.wrap(address(new MockERC20("T", "T", 18)));
        PoolKey memory key = PoolKey({
            currency0: token,
            currency1: CurrencyLibrary.ADDRESS_ZERO,
            fee: 3000,
            tickSpacing: 60,
            hooks: IHooks(address(0))
        });
        vm.expectRevert();
        manager.initialize(key, SQRT_PRICE_1_1);
    }
}

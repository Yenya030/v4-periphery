// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {V4Quoter} from "../src/lens/V4Quoter.sol";
import {IPoolManager} from "@uniswap/v4-core/src/interfaces/IPoolManager.sol";
import {IHooks} from "@uniswap/v4-core/src/interfaces/IHooks.sol";
import {PoolKey} from "@uniswap/v4-core/src/types/PoolKey.sol";
import {Currency} from "@uniswap/v4-core/src/types/Currency.sol";
import {QuoterRevert} from "../src/libraries/QuoterRevert.sol";
import {IV4Quoter} from "../src/interfaces/IV4Quoter.sol";

contract DummyPoolManager {
    function unlock(bytes calldata) external pure returns (bytes memory) {
        QuoterRevert.revertQuote(123);
    }
}

contract V4QuoterMsgSenderResetTest is Test {
    V4Quoter quoter;
    DummyPoolManager manager;

    function setUp() public {
        manager = new DummyPoolManager();
        quoter = new V4Quoter(IPoolManager(address(manager)));
    }

    function test_msgSender_resets_after_quote() public {
        IV4Quoter.QuoteExactSingleParams memory params = IV4Quoter.QuoteExactSingleParams({
            poolKey: PoolKey({
                currency0: Currency.wrap(address(0)),
                currency1: Currency.wrap(address(0)),
                fee: 3000,
                tickSpacing: 60,
                hooks: IHooks(address(0))
            }),
            zeroForOne: true,
            exactAmount: 100,
            hookData: ""
        });

        quoter.quoteExactInputSingle(params);
        assertEq(quoter.msgSender(), address(0));
    }
}


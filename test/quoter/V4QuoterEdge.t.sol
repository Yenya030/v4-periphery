// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {Deployers} from "@uniswap/v4-core/test/utils/Deployers.sol";
import {Deploy, IV4Quoter} from "../shared/Deploy.sol";
import {V4Quoter} from "../../src/lens/V4Quoter.sol";
import {BaseV4Quoter} from "../../src/base/BaseV4Quoter.sol";
import {PoolKey} from "@uniswap/v4-core/src/types/PoolKey.sol";
import {IHooks} from "@uniswap/v4-core/src/interfaces/IHooks.sol";
import {QuoterRevert} from "../../src/libraries/QuoterRevert.sol";

contract V4QuoterEdgeTest is Test, Deployers {
    V4Quoter public quoter;

    function setUp() public {
        deployFreshManagerAndRouters();
        deployMintAndApprove2Currencies();
        quoter = V4Quoter(address(Deploy.v4Quoter(address(manager), hex"01")));
    }

    function test_quoteExactInputSingle_selfOnly_reverts() public {
        (PoolKey memory poolKey,) = initPool(currency0, currency1, IHooks(address(0)), 3000, SQRT_PRICE_1_1);
        IV4Quoter.QuoteExactSingleParams memory params =
            IV4Quoter.QuoteExactSingleParams({poolKey: poolKey, zeroForOne: true, exactAmount: 1, hookData: ""});
        vm.expectRevert(BaseV4Quoter.NotSelf.selector);
        quoter._quoteExactInputSingle(params);
    }

    function test_quoteExactInputSingle_insufficientLiquidity_reverts() public {
        (PoolKey memory poolKey,) = initPool(currency0, currency1, IHooks(address(0)), 3000, SQRT_PRICE_1_1);
        IV4Quoter.QuoteExactSingleParams memory params =
            IV4Quoter.QuoteExactSingleParams({poolKey: poolKey, zeroForOne: true, exactAmount: 100, hookData: ""});
        bytes memory reason = abi.encodeWithSelector(BaseV4Quoter.NotEnoughLiquidity.selector, poolKey.toId());
        vm.expectRevert(abi.encodeWithSelector(QuoterRevert.UnexpectedRevertBytes.selector, reason));
        quoter.quoteExactInputSingle(params);
    }
}

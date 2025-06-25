// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {V4Router} from "../src/V4Router.sol";
import {IV4Router} from "../src/interfaces/IV4Router.sol";
import {ActionConstants} from "../src/libraries/ActionConstants.sol";
import {IPoolManager} from "@uniswap/v4-core/src/interfaces/IPoolManager.sol";
import {PoolKey} from "@uniswap/v4-core/src/types/PoolKey.sol";
import {IHooks} from "@uniswap/v4-core/src/interfaces/IHooks.sol";
import {ReentrancyLock} from "../src/base/ReentrancyLock.sol";
import {Currency} from "@uniswap/v4-core/src/types/Currency.sol";
import {SwapParams} from "@uniswap/v4-core/src/types/PoolOperation.sol";
import {TickMath} from "@uniswap/v4-core/src/libraries/TickMath.sol";
import {BalanceDelta} from "@uniswap/v4-core/src/types/BalanceDelta.sol";
import {SafeCast} from "@uniswap/v4-core/src/libraries/SafeCast.sol";

contract MockPoolManager {
    mapping(bytes32 => int256) public deltas;
    int256 public lastAmountSpecified;

    function setDelta(address owner, Currency currency, int256 delta) external {
        deltas[keccak256(abi.encode(owner, Currency.unwrap(currency)))] = delta;
    }

    function currencyDelta(address owner, Currency currency) external view returns (int256) {
        return deltas[keccak256(abi.encode(owner, Currency.unwrap(currency)))];
    }

    function swap(PoolKey memory, SwapParams memory params, bytes calldata) external returns (BalanceDelta) {
        lastAmountSpecified = params.amountSpecified;
        return BalanceDelta.wrap(0);
    }
    function exttload(bytes32 slot) external view returns (bytes32 value) { return bytes32(uint256(int256(deltas[slot]))); }
}

contract RouterHarness is V4Router, ReentrancyLock {
    using SafeCast for int256;
    using SafeCast for uint256;

    constructor(IPoolManager pm) V4Router(pm) {}

    function msgSender() public view override returns (address) { return _getLocker(); }
    int256 public recordedAmountSpecified;

    function swapExactInputSingleHarness(IV4Router.ExactInputSingleParams memory params) external {
        uint128 amountIn = params.amountIn;
        if (amountIn == ActionConstants.OPEN_DELTA) {
            amountIn = _getFullCredit(params.zeroForOne ? params.poolKey.currency0 : params.poolKey.currency1).toUint128();
        }
        recordedAmountSpecified = -int256(uint256(amountIn));
        _swapInternal(params.poolKey, params.zeroForOne, recordedAmountSpecified, params.hookData);
    }

    function _swapInternal(PoolKey memory poolKey, bool zeroForOne, int256 amountSpecified, bytes memory hookData)
        internal
        returns (int128 reciprocalAmount)
    {
        BalanceDelta delta = MockPoolManager(address(poolManager)).swap(
            poolKey,
            SwapParams({
                zeroForOne: zeroForOne,
                amountSpecified: amountSpecified,
                sqrtPriceLimitX96: zeroForOne ? TickMath.MIN_SQRT_PRICE + 1 : TickMath.MAX_SQRT_PRICE - 1
            }),
            hookData
        );
        reciprocalAmount = (zeroForOne == amountSpecified < 0) ? delta.amount1() : delta.amount0();
    }

    function _pay(Currency, address, uint256) internal override {}
}

contract OpenDeltaMisuseTest is Test {
    MockPoolManager manager;
    RouterHarness router;
    Currency token0;
    Currency token1;
    PoolKey key;

    function setUp() public {
        manager = new MockPoolManager();
        router = new RouterHarness(IPoolManager(address(manager)));
        token0 = Currency.wrap(address(0x1));
        token1 = Currency.wrap(address(0x2));
        key = PoolKey({currency0: token0, currency1: token1, fee: 3000, tickSpacing: 1, hooks: IHooks(address(0))});
        manager.setDelta(address(router), token0, 1000 ether);
    }

    function testZeroAmountTriggersFullSwap() public {
        IV4Router.ExactInputSingleParams memory params = IV4Router.ExactInputSingleParams({
            poolKey: key,
            zeroForOne: true,
            amountIn: ActionConstants.OPEN_DELTA,
            amountOutMinimum: 0,
            hookData: bytes("")
        });

        router.swapExactInputSingleHarness(params);

        assertEq(manager.lastAmountSpecified(), -int256(1000 ether));
        assertEq(router.recordedAmountSpecified(), -int256(1000 ether));
    }
}


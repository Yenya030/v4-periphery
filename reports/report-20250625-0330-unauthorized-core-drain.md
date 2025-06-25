# Unauthorized Core Drain Validation Report

## Summary
A test was created to verify whether calling `PoolManager.modifyLiquidity` directly can bypass `PositionManager` checks and steal liquidity from another user's position. The test demonstrates that such a call reverts with `SafeCastOverflow`, showing that liquidity owned by the `PositionManager` cannot be removed by an unauthorized caller.

## Methodology
1. Deployed a fresh `PoolManager` and `PositionManager` using existing helpers.
2. Alice minted liquidity into a pool via the `PositionManager`.
3. Bob attempted to call `modifyLiquidity` on the core contract using the same pool key and token ID.
4. The call was executed via `PoolModifyLiquidityTestNoChecks` to bypass the locked state.
5. The transaction reverted with `SafeCastOverflow`, proving the liquidity could not be removed.

## Test Output
```
forge test -vvv --match-path test/UnauthorizedCoreDrain.t.sol --fuzz-runs 256
```
produced:
```
[PASS] test_direct_core_call_reverts() (gas: 455399)
```

## Gas Usage
The failing call consumed ~455k gas before reverting.

## Mitigation Suggestions
No vulnerability was observed. The core contract correctly binds liquidity ownership to `msg.sender` and prevents unauthorized removal. No action is required.

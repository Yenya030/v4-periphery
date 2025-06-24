# Remove Liquidity Cast Bug Validation

## Summary
Negative liquidity deltas returned by hooks now cause a revert during `validateMinOut`. The SafeCast library protects the conversion from `int128` to `uint128`, preventing the previously reported wraparound.

## Methodology
- Deployed a custom `NegativeDeltaHook` that always returns a negative `BalanceDelta` on `afterRemoveLiquidity`.
- Minted liquidity and attempted to remove it with `amount0Min` and `amount1Min` set to `type(uint128).max`.
- Fuzzed liquidity amounts and delta magnitudes.
- Observed that `modifyLiquidities` reverts, confirming SafeCast prevents wrapping.

## Findings
- All fuzz runs reverted as expected. The revert occurs before the slippage check due to `SafeCastOverflow`.
- No user funds were withdrawn when the delta was negative.

## Conclusion
✅ **No bug** – current HEAD correctly reverts when negative liquidity deltas are cast. The unsafe cast issue reported in the audit has been addressed by using `SafeCast.toUint128`.

## References
- [`SlippageCheck.validateMinOut`](src/libraries/SlippageCheck.sol)
- Test implementation [`RemoveLiquidityCastBug.t.sol`](test/position-managers/RemoveLiquidityCastBug.t.sol)

# Slippage Gap Validation for Hooks

## Methodology
- Implemented custom hooks returning sign-adjusted `BalanceDelta` values.
- Added fuzz test `NegativeDeltaRemoveTest` to ensure negative deltas revert via `SafeCast` when removing liquidity.
- Leveraged a library harness in `PositiveDeltaLibraryTest` to confirm positive deltas skip slippage checks in `validateMaxIn`.

## Results
- `NegativeDeltaRemoveTest` consistently reverted when hooks returned negative deltas, preventing withdrawals.
- `PositiveDeltaLibraryTest` executed without revert, showing slippage checks are bypassed with positive deltas.

## Impact
These behaviors align with audit findings that hooks can bypass or block slippage guarantees depending on delta sign.

## Recommendations
- Enforce explicit limits on hook-provided deltas within `SlippageCheck` to avoid user-surprising behavior.

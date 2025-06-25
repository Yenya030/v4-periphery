# Tests for WstETHHook helpers and StateView overload

## Summary
Added tests covering `WstETHHook` internal helper functions for calculating wrap and unwrap requirements and verified the alternative overload of `StateView.getPositionInfo` that accepts explicit parameters.

## Test Methodology
- Created a `WstETHHookHarness` exposing `_getWrapInputRequired` and `_getUnwrapInputRequired`.
- Added `WstETHHookInternalTest` to validate these functions using the mock `wstETH` exchange rate.
- Added `StateViewGetPositionInfoOverload` test comparing results of the position info overload with the existing positionId variant after performing swaps and liquidity modifications.

## Findings
- `WstETHHook` correctly derives required amounts based on `tokensPerStEth` and `getWstETHByStETH`.
- Both overloads of `getPositionInfo` return identical values, ensuring API consistency.

## Conclusion
Coverage gaps for wrapper amount calculations and StateView overload behavior are now exercised. No issues were uncovered.

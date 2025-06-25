# Wrap Orientation and Rate Calculations

This report documents additional tests for token wrapper hooks in Uniswap V4. The goal was to verify the orientation flag and rate helpers exposed by `BaseTokenWrapperHook` implementations.

## Test Methodology
- Created a harness `WstETHHookHarness` exposing internal view functions.
- Added `WETHHookInternalTest` and `WstETHHookInternalTest` to check:
  - `wrapZeroForOne` is computed based on token ordering.
  - Rate helper functions `_getWrapInputRequired` and `_getUnwrapInputRequired` match expectations for the wstETH exchange rate.

## Test Steps
- Deploy hooks at deterministic addresses with proper permissions using `deployCodeTo`.
- Call public harness functions and assert returned values.

## Findings
- Both hooks report `wrapZeroForOne` as `true` when the underlying token address is less than the wrapper token address.
- Required amounts from the rate helper functions matched the mocked exchange rate, including rounding behavior.
- No defects were discovered; tests passed as expected.

## Conclusion
The new tests cover internal logic previously untested around orientation and rate calculations for wrapper hooks. All checks succeeded.

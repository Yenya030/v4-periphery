# Zero Hop Swap Tests - 20250627

## Summary
This report covers new test cases targeting zero-hop swap scenarios in `V4Router`. The goal was to ensure edge cases where the swap path is empty behave as expected.

## Test Methodology
- **swapExactIn_zeroHop_reverts**: verifies that providing no path for an exact-input swap causes a `V4TooLittleReceived` revert when a minimum amount is specified.
- **swapExactOut_zeroHop_noop**: checks that a zero-hop exact-output swap performs no action and leaves token balances unchanged.

## Test Steps
- Constructed empty `tokenPath` arrays for each new test.
- Used existing helpers to create `ExactInputParams` and `ExactOutputParams` with these paths.
- Executed actions via the router and captured balance changes.

## Findings
- **swapExactIn_zeroHop_reverts**: reverted with `V4TooLittleReceived` as expected, confirming safety against nonsensical swaps.
- **swapExactOut_zeroHop_noop**: executed successfully without altering balances, showing the router treats such calls as no-ops.

## Conclusion
Zero-hop swap cases now have explicit coverage. The router correctly reverts when a minimum output is required and otherwise results in a no-op. No flaws were discovered.

# NativeWrapper unwrap failure coverage

## Summary
This report adds a targeted test for `NativeWrapper` to verify that calling `unwrap` with more WETH than held reverts. Existing tests covered successful unwraps but did not check the revert path.

## Test Methodology
- Reviewed coverage results from `forge coverage` and spotted that `NativeWrapper._unwrap` was only exercised once and never for failure.
- Wrote `test_unwrap_insufficient_balance_reverts` to attempt withdrawing without any WETH balance.

## Test Steps
- Deploy `NativeWrapperHarness` with a fresh WETH instance.
- Without depositing WETH, call `wrapper.unwrap(1 ether)` expecting a revert.

## Findings
- The new test passed, confirming the contract reverts when the balance is insufficient.
- Coverage for `_unwrap` now includes the failure branch.

## Conclusion
No flaws were found in `NativeWrapper` logic. The added test improves coverage of error handling for the unwrap path.

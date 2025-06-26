# Unsubscribe Gas Limit Verification

This report documents testing around the `Notifier` unsubscribe gas limit checks.

## Test Methodology
- Focused on `Notifier._unsubscribe` which reverts with `GasLimitTooLow` if remaining gas is below `unsubscribeGasLimit`.
- Added a unit test in `NotifierHarness.t.sol` to subscribe a token and then call `_unsubscribe` with insufficient gas.
- Asserted that the call reverts and the subscriber mapping remains unchanged.

## Test Steps
- Deploy `NotifierHarness` with gas limit 100000.
- Subscribe token ID 5 to `SimpleSubscriber`.
- Call `unsubscribeWrap` with `gas = unsubscribeGasLimit - 1` expecting `GasLimitTooLow` revert.
- Verify subscriber address remains stored.

## Findings
- The new test passed confirming the revert occurs as expected when gas is insufficient.
- No unexpected behavior observed; existing logic handles low gas properly.

## Conclusion
The added test covers a previously untested edge in `Notifier` ensuring gas limit enforcement. The unsubscribe mechanism functions correctly under constrained gas.

# NativeWrapper Wrap Functions - New Tests

## Summary
This report documents additional tests added to cover the `NativeWrapper` contract's `_wrap` logic. The goal was to verify that wrapping ETH correctly deposits WETH and that insufficient value reverts.

## Test Methodology
- **`test_wrap_deposits_weth`** ensures that calling `wrap` with the correct amount mints WETH to the wrapper and leaves no ETH residue.
- **`test_wrap_insufficient_value_reverts`** checks that calling `wrap` without sending the required ETH reverts due to an `OutOfFunds` error.

## Test Steps
1. Deploy a `NativeWrapperHarness` with mock WETH and pool manager.
2. Execute `wrap` with appropriate ETH and verify balances.
3. Attempt wrapping without value and expect revert.

## Findings
- Wrapping deposits WETH as expected and leaves the wrapper with zero ETH balance.
- Calls with insufficient ETH revert with an out-of-funds error, demonstrating proper enforcement of value transfer.

## Conclusion
The added tests fill gaps in the `NativeWrapper` helper by exercising successful and failing wrap paths. No issues were observed in the implementation.

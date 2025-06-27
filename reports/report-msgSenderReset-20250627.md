# MsgSender Reset After Quote

This report verifies that `V4Quoter` correctly clears the transient sender after a quoting call.

## Summary
- Added a new test `V4QuoterMsgSenderResetTest` focusing on the `setMsgSender` modifier in `V4Quoter`.
- The test deploys a minimal `DummyPoolManager` whose `unlock` function reverts with a `QuoteSwap` error. This triggers the quoter's catch block without performing any pool logic.
- After calling `quoteExactInputSingle`, the test asserts that `msgSender()` returns the zero address, proving the locker was cleared.

## Test Steps
- Deploy `DummyPoolManager` and `V4Quoter`.
- Call `quoteExactInputSingle` with trivial parameters; the pool manager revert supplies a quote amount.
- Immediately read `msgSender()` and expect `address(0)`.

## Findings
- The test passed, confirming that the `setMsgSender` modifier resets the locker even when quoting completes via a revert-based flow.


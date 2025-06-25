# V4Quoter unexpected success path coverage

## Summary
This report documents the addition of a test covering `BaseV4Quoter`'s `UnexpectedCallSuccess` revert. The goal was to verify that `unlockCallback` reverts when the delegated call does not revert as expected.

## Methodology
After reviewing existing tests, no case exercised the `UnexpectedCallSuccess` error in `BaseV4Quoter`. A minimal harness was built using a dummy `PoolManager` contract able to call `unlockCallback` on the quoter. The test invokes `unlockCallback` with data that calls `msgSender()`, which returns normally and should trigger the revert.

## Test Steps
- Deploy a `DummyPoolManager`.
- Deploy `V4Quoter` using this dummy as the pool manager.
- Encode a call to `quoter.msgSender()` and call `unlockCallback` via the dummy.
- Expect `BaseV4Quoter.UnexpectedCallSuccess` to be reverted.

## Findings
- The test succeeded, confirming the quoter reverts with `UnexpectedCallSuccess` when the delegated call does not revert.
- No bugs were found; the behavior matches expectations.

## Conclusion
The additional test improves coverage around `BaseV4Quoter`'s defensive revert path. No issues were uncovered, but the test ensures this edge case will remain verified in future changes.

# Unsubscribe External Coverage

## Summary
This report targets the `Notifier.unsubscribe` function in the Uniswap v4 periphery. Prior coverage focused on the internal `_unsubscribe` logic, leaving the external wrapper untested. The new tests verify that the public method correctly updates state, emits notifications via the subscriber, and enforces the NotSubscribed revert.

## Test Methodology
- **Coverage gap** identified by inspecting `lcov.info` which showed zero hits for `Notifier.unsubscribe`.
- Crafted tests in `NotifierHarness.t.sol` to invoke `unsubscribe` directly.

## Test Steps
- `test_unsubscribe_external_success` subscribes a `SimpleSubscriber` then calls `unsubscribe`. Assertions check the subscriber counter and that the subscriber mapping is cleared.
- `test_unsubscribe_external_notSubscribed` calls `unsubscribe` on a token with no subscriber and expects the `NotSubscribed` error.

## Findings
- Both tests pass, confirming the external function behaves the same as the internal helper while covering previously untouched lines.

## Conclusion
`Notifier.unsubscribe` is now covered by unit tests, eliminating the blind spot discovered in coverage output. No defects were detected, but the additional tests ensure future changes are caught if behavior diverges.

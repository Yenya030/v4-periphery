# Notifier Coverage Extension

This report documents additional tests written to exercise the `Notifier` contract which previously showed no direct coverage due to inlining in the `PositionManager` contract.

## Test Methodology
- Created `NotifierHarness` exposing internal functions of `Notifier`.
- Implemented lightweight subscribers (`SimpleSubscriber`, `SimpleRevertSubscriber`) to observe notifications and trigger revert paths without requiring a full position manager.
- Wrote new tests in `NotifierHarness.t.sol` covering normal unsubscribe flows, burn notifications and bubbling revert behaviour.

## Test Steps
- **test_call_noCode_reverts** – `_call` reverts when target has no code.
- **test_unsubscribe_reverts_when_not_subscribed** – ensures `_unsubscribe` validates existence of subscriber.
- **test_unsubscribe_notifies** – verifies unsubscribe notifications are forwarded.
- **test_removeSubscriberAndNotifyBurn** – checks burn notifications delete the subscriber entry.
- **test_notifyModifyLiquidity_revertBubbles** – ensures subscriber revert is wrapped with `WrappedError`.

## Findings
- All new tests pass, exercising paths previously not covered by existing suite.
- The revert wrapping logic correctly surfaces errors from subscriber contracts.
- Coverage tools no longer report zero-hit for `Notifier` functions when running with the harness.

## Conclusion
Additional unit tests now explicitly cover the `Notifier` contract. This confirms expected behaviors for subscription management and revert bubbling while improving overall coverage.

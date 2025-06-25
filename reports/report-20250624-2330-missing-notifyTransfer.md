# Missing `notifyTransfer` Callback in PositionManager

## Summary
Tests show that transferring a position NFT does not trigger a `notifyTransfer` call on subscribers. The `PositionManager` simply unsubscribes the position without informing the subscriber of the new owner.

## Methodology
- Reviewed the `Notifier` contract which claims to send updates "about position modifications or transfers."【F:src/base/Notifier.sol†L10-L11】
- Inspected `PositionManager.transferFrom` which merely calls `_unsubscribe` after transferring the token.【F:src/PositionManager.sol†L534-L538】
- Noted that the current `ISubscriber` interface lacks any `notifyTransfer` function.【F:src/interfaces/ISubscriber.sol†L7-L38】
- Created `MockTransferSubscriber` implementing `notifyTransfer` to detect callbacks.
- Wrote `NotifyTransferTest` which subscribes a position, transfers it, and checks that `notifyTransfer` was never called.

## Findings
```
[PASS] test_safeTransfer_doesNotNotifyTransfer() (gas: 515506)
[PASS] test_transferFrom_doesNotNotifyTransfer() (gas: 512732)
```
The subscriber was removed from `PositionManager` but `notifyTransfer` was never invoked.

## Impact
Subscribers expecting ownership updates will maintain stale state. They are only informed of unsubscription, not of the new owner, breaking any reward or voting logic that should follow the token.

## Recommendations
Implement a transfer hook. Override `_afterTokenTransfer` (or `transferFrom`) to call `notifyTransfer` with a gas-capped `try/catch`, similar to other notifications, and keep the subscriber mapping intact if continued subscription is desired.

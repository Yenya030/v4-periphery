# notifyBurn Denial-of-Service via Subscriber Reverts

## Summary
A malicious subscriber can lock a position by reverting inside `notifyBurn`. Because `PositionManager` forwards all remaining gas to the subscriber without handling errors, the revert bubbles up and prevents `burn()` from completing. Users must first call `unsubscribe`, which is not clearly communicated in high‑level guides.

## Methodology
- Inspected `_removeSubscriberAndNotifyBurn` which deletes the subscriber and calls its `notifyBurn` with full gas and no try/catch.
- Implemented `EvilSubscriber` that always reverts from `notifyBurn`.
- Added regression tests in `SubscriberBurnDoS.t.sol` covering revert scenarios, manual unsubscribe and an out‑of‑gas loop.
- Ran `forge test` to demonstrate behaviour.

## Test Steps
1. Mint a position and subscribe the `EvilSubscriber`.
2. Attempt to burn while subscribed – expect revert wrapped by `CustomRevert`.
3. Unsubscribe then burn again – succeeds and position is removed.
4. Fuzz varying revert data and simulate gas exhaustion with an infinite loop to confirm burns fail whenever the subscriber misbehaves.

## Findings
- `_removeSubscriberAndNotifyBurn` uses `call(gas(), ...)` and bubbles the revert【F:src/base/Notifier.sol†L90-L109】.
- `ISubscriber.notifyBurn` is part of the required interface for subscribers【F:src/interfaces/ISubscriber.sol†L21-L28】.
- Unsubscribe documentation states users can always remove a subscriber if malicious【F:src/interfaces/INotifier.sol†L42-L49】.
- Tests show burning reverts with a wrapped error until `unsubscribe` is executed【F:test/SubscriberBurnDoS.t.sol†L63-L109】.

## Conclusion
The design allows a subscriber to DoS a position by reverting during `notifyBurn`. While the interface notes that unsubscribing is always possible, the PositionManager guide does not highlight that burning a position requires no active subscriber. Mitigation options:
- Mirror the `unsubscribe` pattern with a gas cap and try/catch in `_removeSubscriberAndNotifyBurn`.
- Document that positions must unsubscribe before burning if the subscriber might revert.

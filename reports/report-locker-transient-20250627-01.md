# Locker Transient Storage Behavior

## Summary
The goal was to verify how `Locker`'s transient storage behaves across multiple external calls within the same transaction. All existing tests only examined operations within a single call. The new test demonstrates that the locker value persists across calls in the same transaction.

## Test Methodology
- Focused on `Locker` library, specifically state persistence between calls.
- Assumed transient storage should remain set until the transaction ends.

## Test Steps
- Added `test_value_persists_across_calls_in_tx` in `LockerTest`.
- Call `setLocker` once, then call `getLocker` in a second external call.
- Assert that `getLocker` returns the previously set address.

## Findings
- The new test passes, confirming `Locker.set` values persist across calls within the same transaction.
- No issues were discovered with the library’s logic.

## Conclusion
The additional coverage verifies expected transient storage semantics for `Locker`. No flaws were uncovered.

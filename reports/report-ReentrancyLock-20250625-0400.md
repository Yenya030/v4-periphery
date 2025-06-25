# ReentrancyLock Edge Cases - 20250625

## Summary
This report documents additional tests around the `ReentrancyLock` contract. The goal was to verify the modifier correctly records the caller address during execution and prevents reentrant calls.

## Test Methodology
`ReentrancyLock` was identified as lightly tested because no dedicated test covered `_getLocker()` or the transient storage lock. A new harness contract exposes methods to inspect the locker state and attempt reentrancy. Two focused tests were written:
- **test_lock_and_unlock** checks that the lock stores `msg.sender` during the call and clears afterwards.
- **test_reentrant_call_reverts** triggers a nested call while locked expecting failure and ensuring the lock is cleared.

## Test Steps
1. Deploy `ReentrancyLockHarness` implementing `lockedCaller`, `reentrantAttempt`, and `currentLocker`.
2. Call `lockedCaller` and assert it returns the caller and that `currentLocker` is zero after.
3. Call `reentrantAttempt` which internally calls `lockedCaller` again. Assert the nested call fails and the lock resets to zero.

## Findings
- Both tests pass indicating `isNotLocked` correctly sets and clears the locker and reverts on reentrant calls.
- No functional issues were revealed. The tests increase coverage for the lock mechanism.

## Conclusion
`ReentrancyLock` now has direct tests validating its behavior. Future work could integrate similar checks in other contracts relying on the lock for improved assurance.

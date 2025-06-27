# Reentrancy Lock Behavior on Revert

## Summary
This report exercises the `ReentrancyLock` utility with a new test ensuring that the transient lock is cleared even when a locked function reverts. The baseline suite passed 662 tests. After adding the new test the suite executes 663 tests successfully.

## Test Methodology
- Searched the codebase for under-tested libraries. `ReentrancyLock` lacked coverage for revert paths.
- Added a harness function `revertAfterLock` that reverts inside the `isNotLocked` modifier.
- Implemented a test `test_lock_cleared_on_revert` verifying that the lock resets to zero after a reverting call.

## Test Steps
- `ReentrancyLockHarness.revertAfterLock()` uses `isNotLocked` and immediately reverts.
- The test invokes the function expecting a revert via `try/catch` and then checks `currentLocker()`.

## Findings
- The new test confirms that the lock is cleared when the function reverts, preventing deadlocks.
- All tests pass with the additional case, suggesting no bug in the modifier logic.

## Conclusion
`ReentrancyLock` correctly resets its locker even if a protected function reverts. The added test guards against regressions in this edge case.

# BaseActionsRouter Revert Scenarios

## Summary
This report documents additional tests covering failure cases in `BaseActionsRouter`. The goal was to ensure that improper action arrays and unsupported action identifiers revert as expected.

## Test Methodology
- **Input length mismatch**: executed actions with one entry but zero parameter arrays to confirm `InputLengthMismatch` is triggered.
- **Unsupported action**: passed an undefined action id (`0xff`) to ensure the router reverts with `UnsupportedAction`.

## Test Steps
- Constructed raw actions and params arrays using `abi.encode` and `Planner` helper.
- Used `vm.expectRevert` with the proper error selectors before calling `executeActions`.

## Findings
- Both new tests pass, confirming the router validates input lengths and action ids.

## Conclusion
These tests close coverage gaps in the router's error handling. No new flaws were identified.

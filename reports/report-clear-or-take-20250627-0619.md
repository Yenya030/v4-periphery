# Clear or Take Logic Coverage

## Summary
Added unit tests covering the `_clearOrTake` helper used by `PositionManager` to either forfeit positive deltas or take them from the pool. The new tests verify behavior for zero deltas, deltas below the forfeit maximum and deltas above the maximum.

## Test Methodology
`ClearOrTakeHarness` replicates the internal logic and uses `MockPoolManagerClearOrTake` to track calls to `clear` and `take`. Each test sets up a delta via the mock manager and calls the exposed function.

## Test Steps
- **test_zeroDelta_noCalls** – sets pool delta to zero and asserts no calls are made.
- **test_deltaCleared_whenBelowMax** – sets delta below `amountMax` and confirms `clear` is invoked with the correct amount.
- **test_deltaTaken_whenAboveMax** – sets delta above `amountMax` and checks that `take` is invoked targeting the harness address.

## Findings
All tests passed and confirmed the intended logic. The zero-delta case previously lacked coverage.

## Conclusion
The `_clearOrTake` helper now has dedicated coverage ensuring that both clearing and taking branches behave as expected.

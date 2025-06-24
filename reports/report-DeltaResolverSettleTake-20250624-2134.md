# DeltaResolver mapping tests

## Summary
This report documents targeted tests for the mapping helpers in `DeltaResolver`. Existing coverage did not exercise `_mapSettleAmount` and `_mapTakeAmount`, leaving edge cases around OPEN_DELTA and CONTRACT_BALANCE unchecked. A new test suite was added and all tests continue to pass.

## Test Methodology
- Scanned the repository for functions without dedicated tests. `_mapSettleAmount` and `_mapTakeAmount` were not referenced in any suite.
- Created a minimal harness exposing these internal functions and a mock PoolManager with transient state support.
- Designed deterministic tests around debt/credit scenarios and expected revert conditions.

## Test Steps
- **test_settle_contractBalance**: verifies `_mapSettleAmount` returns the contract balance when passed `CONTRACT_BALANCE`.
- **test_settle_openDelta_usesDebt**: ensures OPEN_DELTA pulls the full debt amount.
- **test_settle_openDelta_revertsOnPositiveDelta**: checks that a positive delta causes `DeltaNotNegative` to revert.
- **test_take_openDelta_usesCredit**: confirms OPEN_DELTA fetches the full credit amount.
- **test_take_openDelta_revertsOnNegativeDelta**: validates that a negative delta triggers `DeltaNotPositive`.

## Findings
- All five new tests passed alongside the existing suite, resulting in 521 successful tests in total.
- The added suite covers previously untested branches of `DeltaResolver` and demonstrated correct revert behaviour.

## Conclusion
The new tests strengthen confidence in the settling and taking helpers without uncovering defects. Future efforts might expand coverage for other internal helpers or integrate coverage reporting into CI for a clearer view of remaining gaps.

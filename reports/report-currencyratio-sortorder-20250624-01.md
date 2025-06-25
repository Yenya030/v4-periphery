# CurrencyRatioSortOrder Constants

## Summary
Added a focused test to verify the numeric values of `CurrencyRatioSortOrder`.
This small library previously lacked direct coverage.

## Methodology
- Ran `forge test` to establish a clean baseline.
- Searched the codebase for libraries without dedicated tests.
  `CurrencyRatioSortOrder.sol` defines constants but had no unit test.
- Crafted `CurrencyRatioSortOrderTest` to assert the expected int values.

## Test Steps
- **test_constants_values** – reads each constant and checks against the
  intended value.

## Findings
- The new test passed and revealed no issues, confirming the constants
  match the documented values.
- Full suite continued to pass after adding this test.

## Conclusion
While no bugs were uncovered, the additional test provides explicit
coverage for this small library and guards against accidental changes.

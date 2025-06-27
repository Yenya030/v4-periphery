# Currency Ratio Ordering Validation 2025-06-27

## Summary
A small gap was identified in coverage for `CurrencyRatioSortOrder`. Existing tests only validated the absolute constant values. A new unit test now asserts the relative ordering between numerator and denominator constants to guard against accidental regressions.

## Methodology
- Reviewed prior coverage reports and noticed `CurrencyRatioSortOrder` constants were only compared to literals.
- Crafted `CurrencyRatioSortOrderOrder.t.sol` verifying the numerical ordering properties.
- Ran the Forge linter and targeted test file to ensure correctness.

## Test Steps
- `test_constant_ordering` checks that `NUMERATOR_MOST > NUMERATOR_MORE > NUMERATOR` and the analogous ordering for the denominator constants. It also asserts numerators are positive and denominators negative.

## Findings
- The new test passed confirming the expected ordering behavior. No issues were found.

## Conclusion
This additional test slightly improves robustness around `CurrencyRatioSortOrder` and demonstrates a systematic approach to locating small coverage gaps.

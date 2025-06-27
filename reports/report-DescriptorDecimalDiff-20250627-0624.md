# Descriptor Decimal Difference Edge

## Summary
Added a targeted unit test ensuring `Descriptor.fixedPointToDecimalString` handles token decimals differing by more than 18. The new test confirms the function returns a normalized price string without error. All tests continue to pass.

## Test Methodology
- Searched for functions lacking direct coverage and found no tests for decimal differences above 18 in `Descriptor.sol`.
- Implemented a harness-based test calling `fixedPointToDecimalString` with base and quote decimals far apart.

## Test Steps
- Deploy a minimal contract exposing `Descriptor.fixedPointToDecimalString`.
- Call with `sqrtRatioX96 = 2**96` and decimals `(40, 0)` then `(0,40)`.
- Assert the returned string equals `"1.0000"` for both orientations.

## Findings
- Both calls succeeded and returned `"1.0000"`, verifying large decimal differences are supported.
- No runtime errors or rounding anomalies were observed.

## Conclusion
The added test exercises an edge case previously untested. Existing logic correctly normalizes prices when currency decimals differ by over 18. No issues detected.

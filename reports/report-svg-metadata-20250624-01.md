# SVG and Currency Metadata Coverage

## Summary
Added targeted tests for SVG helper functions and native currency metadata to increase coverage of libraries.

## Test Methodology
- Verified curve selection logic in `SVG.getCurve` across range boundaries.
- Checked circle generation for in-range, under-range and over-range cases in `SVG.generateSVGCurveCircle`.
- Confirmed `currencySymbol` and `currencyDecimals` return expected values when given the zero address to represent native currency.

## Test Steps
- Created new test cases in `test/libraries/SVG.t.sol` to assert expected curve strings and circle SVG outputs.
- Extended `test/libraries/SafeCurrencyMetadata.t.sol` with native currency symbol and decimals checks.
- Executed `forge test` ensuring all suites pass.

## Findings
- All new assertions passed; no bugs observed in the targeted functions.
- Total test count increased from 550 to 554.

## Conclusion
The additional tests improve coverage for SVG utilities and currency metadata handling. No issues were discovered, indicating existing implementations behave as expected.

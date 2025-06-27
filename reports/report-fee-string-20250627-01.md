# Descriptor Fee String Edge Case

This report documents testing around percent string formatting.

## Methodology
- Scanned coverage results and existing tests to locate untested functions.
- Identified `Descriptor.feeToPercentString` lacked cases for precision beyond four decimals.
- Implemented `DescriptorFeeStringEdgeTest` to check rounding at uncommon values.

## Test Steps
- Added a new forge unit test calling `Descriptor.feeToPercentString` with values `123456` and `4205`.
- Verified the returned strings include the expected decimal precision.

## Findings
- The new test `DescriptorFeeStringEdgeTest` passes, confirming correct handling for `12.3456%` and `0.4205%` values.
- No bugs were discovered; the test supplements existing coverage of fee conversion logic.

## Conclusion
The additional test ensures fractional fee percentages with four digits after the decimal are formatted correctly. Future work could extend coverage to other Descriptor formatting helpers.

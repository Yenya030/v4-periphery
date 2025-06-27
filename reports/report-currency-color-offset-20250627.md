# Descriptor Color Utils Offset Test

This report documents testing for the `currencyToColorHex` function with a non-zero offset.

## Test Methodology
- Added `DescriptorColorUtilsEdgeNewTest` which calls `Descriptor.currencyToColorHex` with an offset of 8 to ensure shifting and zero-padding works.

## Test Steps
- Compile and run `DescriptorColorUtilsEdgeNewTest` using `forge test`.
- Execute the full suite to ensure no regressions.

## Findings
- The new test passes, returning `"001234"` for currency `0x123456` shifted by eight bits.
- Full suite runs successfully with 651 tests passing.

## Conclusion
The additional test confirms proper behavior of `currencyToColorHex` for non-zero offsets. No issues were found.

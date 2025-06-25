# Descriptor color helpers tests

## Summary
Added targeted tests for the `Descriptor` library's color and coordinate helpers which previously lacked direct coverage. Functions `sliceCurrencyHex`, `currencyToColorHex`, and `getCircleCoord` are now verified with deterministic inputs.

## Test Methodology
- Manual review of coverage pointed out that the color helper utilities inside `Descriptor` had no dedicated tests.
- A new test contract `DescriptorColorUtilsTest` calls these internal functions directly.
- Inputs were chosen for straightforward calculation so expected values are clear.

## Test Steps
- **test_sliceCurrencyHex** – extracts a single byte from a constant and checks the numeric result.
- **test_currencyToColorHex** – converts a shifted currency value to a hex string and validates the output.
- **test_getCircleCoord** – ensures the coordinate calculation combines the slice and token id as intended.

## Findings
- All new tests pass confirming correct arithmetic and string formatting for the helper utilities.
- No issues were detected; the tests simply document behaviour.

## Conclusion
These additional tests close a minor gap in the Descriptor library's helper functions. The full suite now reports 570 passing tests.

# HexStrings truncation behaviour

## Summary
This report adds a unit test to document how `HexStrings.toHexStringNoPrefix` handles numbers that require
more digits than the provided length. The function simply truncates the higher-order digits.

## Test Methodology
A new test `test_toHexStringNoPrefix_truncates_excess` was added. It calls the library with a value larger than
fits in the requested length and asserts that only the least significant digits are returned.

## Test Steps
- Invoke `HexStrings.toHexStringNoPrefix(0x123456, 2)`.
- Expect the resulting string to equal `"3456"`.

## Findings
- The test passed, confirming the library truncates without reverting.
- No issues were identified; the behaviour is consistent with existing assumptions.

## Conclusion
The additional test improves documentation of edge cases around hexadecimal string formatting.
No functional bugs were found.

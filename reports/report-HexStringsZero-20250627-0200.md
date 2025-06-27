# HexStrings zero value test

## Summary
Added a new test verifying `HexStrings.toHexStringNoPrefix` handles a zero value correctly. The function should pad the output string with zeros based on the specified length.

## Test Methodology
- Created `HexStringsZeroTest` which calls `toHexStringNoPrefix` with `value=0` and length `2`.
- Asserted that the returned string equals `"0000"`.

## Test Steps
- Added `test/libraries/HexStringsZero.t.sol` containing the new test.
- Ran `forge test` to execute the full suite and confirm no failures.
- Executed `forge coverage` to ensure coverage metrics still generate.

## Findings
- The new test passed, confirming correct behavior for zero inputs.
- Overall test suite remains green with 640 passing tests.

## Conclusion
`HexStrings.toHexStringNoPrefix` handles zero values as expected. Coverage statistics remain unchanged, indicating the additional test integrates cleanly with the suite.

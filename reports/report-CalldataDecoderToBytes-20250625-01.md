# CalldataDecoder toBytes coverage

## Summary
Added new tests for `CalldataDecoder.toBytes` which previously lacked direct coverage. The overall suite remains green and coverage for `CalldataDecoder.sol` improved slightly.

## Test Methodology
- Reviewed `forge coverage` output and noted branch coverage for `CalldataDecoder.sol` around 32% with no tests targeting `toBytes`.
- Implemented a harness contract invoking `toBytes` and wrote tests for successful extraction and truncated data reversion.

## Test Steps
- **test_toBytes_extract**: Encoded two byte strings and verified `toBytes` returns each element correctly.
- **test_toBytes_sliceOutOfBounds**: Provided a deliberately truncated encoding and expected `SliceOutOfBounds` to be raised.

## Findings
- Both tests behave as expected. The revert path is exercised and the function correctly returns bytes when input encoding is valid.
- Coverage totals increased to 77.44% lines with `CalldataDecoder.sol` now at ~52% line coverage.

## Conclusion
The added tests close a gap in `CalldataDecoder`'s input validation logic without revealing any flaws. Future work could further improve branch coverage for its other decoding helpers.

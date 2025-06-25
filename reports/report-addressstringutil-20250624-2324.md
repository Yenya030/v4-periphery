# AddressStringUtil coverage tests

## Summary
Added targeted tests for the `AddressStringUtil` library to increase coverage of input validation and truncated outputs. The new tests ensure zero length reverts and confirm correct hexadecimal output when requesting fewer than 20 address bytes.

## Test Methodology
- Examined coverage output from `forge coverage` and noted `AddressStringUtil.sol` had only ~56% line coverage.
- Existing tests covered full length conversion and one invalid length path. Missing cases were zero length validation and partial output handling.

## Test Steps
- **test_invalid_length_zero**: calls `toAsciiString` with length `0` and expects `InvalidAddressLength` revert.
- **test_toAsciiString_truncated**: converts a test address requesting 3 bytes (length 6) and checks each generated character against expected hexadecimal digits.

## Findings
- The library correctly rejects a zero length request.
- Truncated output matches expected hex digits for the most significant bytes.

## Conclusion
The additional tests raise line and branch coverage for `AddressStringUtil.sol` and verify edge behavior not previously asserted. No issues were uncovered.

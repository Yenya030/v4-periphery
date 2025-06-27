# AddressStringUtil Revert Handling Tests

## Summary
New unit tests verify `AddressStringUtil.toAsciiString` rejects zero length and overly long requests while returning the expected 40-character output for a full address.

## Methodology
- Inspected coverage data and saw `AddressStringUtil.sol` around 56% coverage.
- Created `AddressStringUtilMoreTest` to trigger edge cases not covered before.

## Test Steps
- `test_invalid_length_zero` expects revert when length is zero.
- `test_invalid_length_too_big` expects revert for length > 40.
- `test_full_length_output` checks a known address converts to 40-char hex.

## Findings
All tests passed and coverage improved slightly for `AddressStringUtil`.

## Conclusion
Edge case validation around address-to-string conversion now has explicit tests ensuring proper error handling.

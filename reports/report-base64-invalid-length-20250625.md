# Base64 Decode Edge Case Test

## Summary
Added a new test covering the Base64 decode helper to ensure it reverts for inputs with invalid length. This increases coverage of utility libraries.

## Methodology
- Identified that `Base64.decode` had no negative tests.
- Created `DecodeCaller` contract to call the library in a new test `Base64Test`.
- The test passes a malformed base64 string and expects the revert message.

## Findings
- The library correctly reverts with `invalid base64 decoder input` when the length is not divisible by four.

## Conclusion
All tests including the new one pass, confirming correct error handling in the Base64 library.

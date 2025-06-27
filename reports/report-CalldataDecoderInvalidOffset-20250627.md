# CalldataDecoder Invalid Offset Coverage

## Summary
Added a test ensuring `decodeActionsRouterParams` reverts when the encoded parameter offsets do not follow strict ABI rules. This covers a failure mode previously untested.

## Test Methodology
- Constructed standard encoded calldata for `(bytes, bytes[])`.
- Mutated the first offset so it no longer points to the `actions` length.
- Expected `SliceOutOfBounds` revert when decoding.

## Test Steps
- `CalldataDecoderInvalidOffsetTest.test_decodeActionsRouterParams_invalidOffset_reverts`
  - Encodes one action with a single parameter.
  - Overwrites the first word with an invalid value.
  - Calls `decoder.decodeActionsRouterParams` expecting a revert.

## Findings
- The decoder correctly reverted with `SliceOutOfBounds`, confirming strict encoding checks.

## Conclusion
This additional test increases branch coverage in `CalldataDecoder` by exercising an error path for malformed offsets.

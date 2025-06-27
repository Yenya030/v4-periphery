# Calldata Decoder Short Parameter Tests

## Summary
This report documents adding targeted tests for `CalldataDecoder` swap decoding functions. The goal was to verify that these functions revert with `SliceOutOfBounds` when given calldata shorter than the minimal encoding length. Prior to these tests the failure paths were untested.

## Test Methodology
- Reviewed coverage output and observed low coverage for `src/libraries/CalldataDecoder.sol` functions.
- Noted absence of tests that intentionally supply insufficient calldata lengths for `decodeSwapExactIn{,Single}Params` and `decodeSwapExactOut{,Single}Params`.
- Wrote a new contract `CalldataDecoderSwapShortTest` using `MockCalldataDecoder` to invoke library functions in calldata context.
- Truncated valid encoded parameters below their required byte lengths (0xa0 or 0x140) before calling the decoder.

## Test Steps
- **test_decodeSwapExactInParams_shortReverts**: Passes `ExactInputParams` truncated to 159 bytes and asserts revert.
- **test_decodeSwapExactInSingleParams_shortReverts**: Uses `ExactInputSingleParams` truncated to 319 bytes.
- **test_decodeSwapExactOutParams_shortReverts**: Uses `ExactOutputParams` truncated to 159 bytes.
- **test_decodeSwapExactOutSingleParams_shortReverts**: Uses `ExactOutputSingleParams` truncated to 319 bytes.

## Findings
- All new tests reverted as expected, confirming the decoder guards against undersized calldata.
- Running the entire suite now yields `645` passing tests.

## Conclusion
The additional checks increase coverage for failure scenarios in `CalldataDecoder.sol`. No functional defects were uncovered; the library correctly rejects malformed calldata. Future work could extend testing to other seldom-used revert branches or fuzz edge cases around malformed path arrays.

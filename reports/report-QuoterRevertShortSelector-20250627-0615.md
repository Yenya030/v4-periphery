# QuoterRevert Short Selector Handling

## Summary
This test checks how `QuoterRevert.parseQuoteAmount` handles revert data that only
contains the `QuoteSwap` selector. The library returns `0` instead of reverting.

## Test Methodology
- Created `QuoterRevertEdgeShort.t.sol` with a wrapper contract exposing the
  parsing function.
- Passed revert bytes with only the selector and no encoded `uint256` amount.

## Test Steps
- Deploy wrapper and call `callParse` with `abi.encodePacked(QuoteSwap.selector)`.
- Assert the returned value equals zero.

## Findings
- The library does not validate the length of the revert data and returns `0`
  when the encoded amount is missing. No revert is thrown.

## Conclusion
`QuoterRevert.parseQuoteAmount` treats a truncated revert payload as a valid
quote of zero. Existing tests did not cover this case. The current behavior may
be acceptable but should be documented if intentional.

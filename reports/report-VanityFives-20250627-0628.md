# VanityAddressLib Additional Coverage

## Summary
Targeted test added to verify scoring for addresses starting with more than four `4` nibbles. Suite continues to pass.

## Test Methodology
- Reviewed existing tests which covered all zero and mixed nibble cases but lacked a scenario where five leading `4` nibbles appear without being all fours.
- Crafted a deterministic unit test calculating the score for `0x4444444000000000000000000000000000004444`.

## Test Steps
- Added `test_scoreLeadingFives` in `VanityAddressLib.t.sol` that asserts the computed score equals `71`.
- Ran `forge test` to ensure the full suite still passes.

## Findings
- New test passed confirming correct handling of more than four leading fours.
- No regressions detected across 662 existing tests.

## Conclusion
The additional case improves coverage for `VanityAddressLib.score` edge conditions without affecting other functionality.

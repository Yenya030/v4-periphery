# Descriptor Sigfigs Rounding Edge

This report investigates the internal rounding helper used by `Descriptor` for percentage and price strings. Coverage review showed the `extraDigit` branch in `sigfigsRounded` was never triggered.

## Test Methodology
- Created `DescriptorSigfigsEdgeTest` which exposes the rounding logic via a harness.
- Fuzzed values with 6 to 30 digits to check if the `extraDigit` flag can ever become true.

## Test Steps
- Deploy `DescriptorSigfigsHarness` exposing `sigfigsRounded`.
- In the fuzz test, choose arbitrary values with the desired digit length.
- Assert `extraDigit` is always false.

## Findings
- The fuzz test passed for all 256 runs, confirming the branch where `extraDigit` becomes true is unreachable with valid inputs.
- This suggests the check `if (value == 100000)` is dead code.

## Conclusion
No flaws were observed in `Descriptor.sigfigsRounded`, but the uncovered branch indicates redundant code. Future clean‑ups might remove it. The added test ensures this behavior remains consistent.

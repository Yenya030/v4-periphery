# Descriptor math edge tests

## Summary
Added focused unit tests covering the `overRange` and scaling logic used in `Descriptor`. A harness exposes simplified versions of these calculations so corner cases can be validated directly.

## Methodology
- Searched library implementations for functions lacking dedicated tests. `Descriptor.overRange` and the internal `scale` helper were found to have no explicit coverage.
- Created `DescriptorMathHarness` to mirror these routines and allow direct invocation in tests.
- Implemented `DescriptorMathEdgeTest` verifying behaviour when the current tick is below, above or within bounds, and that scaling values map linearly from one range to another.

## Test Steps
- Deployed the harness in `setUp`.
- `test_overRange_returnsMinusOne` checks a tick below range.
- `test_overRange_returnsOne` checks a tick above range.
- `test_overRange_returnsZero` checks a tick within range.
- `test_scale_mapsRange` validates scaling of three representative inputs.

## Findings
All new tests passed, confirming the expected arithmetic behaviour.

## Conclusion
Private utility math was not previously unit tested. The added tests provide direct verification and act as usage examples. No logic issues were discovered.

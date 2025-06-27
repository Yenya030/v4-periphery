# Permit2 compact signature coverage

## Summary
Added targeted test to exercise `Permit2SignatureHelpers.getCompactPermitSignature` and `_getCompactSignature` which previously lacked coverage.

## Test Methodology
- Ran full test suite with `forge test` to establish baseline (662 passing).
- Examined `lcov.info` and found zero coverage for the compact signature helpers.
- Created `Permit2SignatureHelpersExtra.t.sol` to call `getCompactPermitSignature` and compare to manual output from `_getCompactSignature`.

## Test Steps
- Build a default permit using `defaultERC20PermitAllowance`.
- Sign with a fixed private key and domain separator.
- Invoke `getCompactPermitSignature` to produce a compact signature.
- Recompute `(r,vs)` using `_getCompactSignature` and assert equality and 64-byte length.

## Findings
- New test executed successfully and increased coverage counts for both helper functions.
- No functional issues observed.

## Conclusion
Targeted test filled the previous gap in `Permit2SignatureHelpers`. Full suite now reports 663 passing tests.

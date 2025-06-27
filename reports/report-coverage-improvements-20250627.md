# Coverage Improvements 2025-06-27

## Summary
Added tests for internal approval checks in `ERC721Permit_v4` and the parameterized `StateView.getPositionInfo` path. These tests increase coverage for previously untouched functions.

## Methodology
- Identified functions with zero execution counts in `lcov.info`, specifically `ERC721Permit_v4._isApprovedOrOwner` and `StateView.getPositionInfo` with explicit parameters.
- Created a harness contract exposing `_isApprovedOrOwner`.
- Wrote unit tests exercising owner, approved, and unauthorized cases.
- Added a new test invoking `StateView.getPositionInfo` with owner and tick parameters and verifying liquidity and fee growth values.

## Test Steps
- `ERC721Permit.isApproved.t.sol` validates `_isApprovedOrOwner` for owner, approved spender, and unapproved spender.
- `StateViewTest.t.sol` `test_getPositionInfo_fullParams` adds liquidity, performs a swap, updates fees, then queries position info using all parameters.

## Findings
- All new tests pass, confirming correct behavior for the previously uncovered code paths.

## Conclusion
The suite now covers additional approval logic and position query pathways. No issues were found.

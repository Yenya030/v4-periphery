# ERC721 Permit Coverage Report

## Summary
This report documents running the full test suite for both the periphery and core packages of Uniswap v4 and adding a new test to cover the previously untested `_isApprovedOrOwner` function.

## Test Methodology
- Executed `forge test` in the periphery repository and within `lib/v4-core` to run all 666 tests.
- Generated coverage via `forge coverage` producing an LCOV report.
- Examined `coverage.xml` and identified that `ERC721Permit_v4._isApprovedOrOwner` had zero line coverage.
- Created `ERC721PermitHarness` to expose the internal helper and wrote `ERC721PermitIsApprovedOrOwner.t.sol` with targeted cases for owner, approved spender, operator, and unapproved addresses.

## Test Steps
- Fixed an incorrect import in `StaleSubscriberOnTransfer.t.sol` preventing coverage from running.
- Added harness and new test contract exercising `_isApprovedOrOwner`.
- Reran the full test suite ensuring all tests pass.

## Findings
- All existing tests and the new ones pass successfully as shown at the end of the run:
```
Ran 105 test suites in 98.96s (135.17s CPU time): 666 tests passed, 0 failed, 0 skipped (666 total tests)
```
- Coverage generation completed without errors and now includes the new test paths.

## Conclusion
The additional test improves coverage for `ERC721Permit_v4`, ensuring the internal permission check behaves correctly. No functional bugs were uncovered during this effort.

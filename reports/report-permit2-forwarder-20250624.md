# Permit2 Forwarder and Base Router Tests

## Summary
Added targeted tests for mapping payer address in `BaseActionsRouter` and for handling revert scenarios in `Permit2Forwarder`. A mock `RevertingPermit2` contract simulates failure paths.

## Test Methodology
- **Map Payer**: Exposed internal `_mapPayer` via `MockBaseActionsRouter` and verified outputs for both user and contract scenarios.
- **Permit2 Forwarder**: Created `RevertingPermit2` to force `permit` and `permitBatch` calls to revert and checked returned error bytes.

## Test Steps
- `test_mapPayer` checks address returned when payer is the user vs. the contract.
- `test_permit_single_returns_error_on_revert` uses the mock to simulate failure of a single permit.
- `test_permit_batch_returns_error_on_revert` does the same for batch permits.

## Findings
- Functions behave as expected under both normal and reverting conditions.
- No unexpected failures observed across the full suite of `519` tests.

## Conclusion
The added tests cover previously untested branches, ensuring correct payer mapping and robust error handling in permit forwarding.

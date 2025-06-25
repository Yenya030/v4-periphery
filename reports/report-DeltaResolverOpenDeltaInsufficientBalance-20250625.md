# DeltaResolver OPEN_DELTA Insufficient Balance Test

## Summary
Added a new test covering `_mapWrapUnwrapAmount` when `OPEN_DELTA` exceeds the contract balance. The function should revert with `InsufficientBalance`.

## Test Methodology
- Initialized a harness contract and set a negative delta (`-10`) on the mock pool manager.
- Minted only `5` tokens to the harness so its balance was less than the debt.
- Called `expose_mapWrapUnwrapAmount` with `OPEN_DELTA` and expected a revert.

## Test Steps
1. Set the pool manager's delta for the harness to `-10` tokens.
2. Mint `5` tokens to the harness.
3. Expect `DeltaResolver.InsufficientBalance` revert when calling `_mapWrapUnwrapAmount` with `OPEN_DELTA`.

## Findings
- The test passed, confirming the revert path works when debt exceeds balance.

## Conclusion
This test increases coverage of `DeltaResolver` by asserting behavior for `OPEN_DELTA` with insufficient balance, which was previously untested.

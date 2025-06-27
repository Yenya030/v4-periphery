# PoolInitializer revert behavior

## Summary
Added a regression test verifying that PoolInitializer returns the max tick and leaves the pool manager state untouched when initialization reverts.

## Test Methodology
Examined PoolInitializer_v4's try/catch logic and hypothesized that state changes in the manager persist even on revert. Crafted a test to check `MockPoolManagerInit.lastPrice` after a failing initialize call.

## Test Steps
- Deploy `MockPoolManagerInit` configured to revert.
- Call `initializePool` via a harness with a specific price.
- Assert returned tick is `type(int24).max` and `lastPrice` remains zero.

## Findings
The new test confirms that state changes in the pool manager revert along with the call, leaving `lastPrice` unchanged. The prior assumption of persistence was invalid.

## Conclusion
PoolInitializer correctly catches failed initialization without side effects. No issue found.

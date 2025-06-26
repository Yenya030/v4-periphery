# Router Unsupported Action Test

This report documents testing for the Uniswap v4 router's handling of unsupported action codes.

## Test Methodology
- Reviewed existing coverage and found no explicit test that verifies `V4Router` reverts when passed an undefined action.
- Created a new test `V4RouterUnsupportedAction.t.sol` that builds an actions plan with action `0xff` and expects the router to revert with `BaseActionsRouter.UnsupportedAction`.

## Test Steps
1. Deploy a fresh pool manager and router with liquidity using `setupRouterCurrenciesAndPoolsWithLiquidity()`.
2. Build a `Planner` with an unsupported action `0xff` and no parameters.
3. Call `router.executeActions` with this plan.
4. Assert that the call reverts with `UnsupportedAction`.

## Findings
- The new test `test_executeActions_unsupportedAction_reverts` passes, confirming the router properly rejects invalid actions.

## Conclusion
The router's handling of unsupported actions behaves as expected. This test extends coverage to an edge case previously untested directly on `V4Router`.

# SlippageCheck additional branch tests

## Summary
Added targeted tests exercising failure cases for `SlippageCheck.validateMinOut` when either token0 or token1 amount is below the minimum threshold. Baseline tests only covered success and overflow scenarios.

## Test Methodology
- Created two new test cases in `SlippageCheck.t.sol`.
- Each constructs a `BalanceDelta` with sufficient liquidity for one token and insufficient for the other.
- Expect a revert with `MinimumAmountInsufficient` for the failing token.

## Test Steps
- `test_validateMinOut_revert_amount0` sends a delta of `(4,10)` and requires `(5,9)`.
- `test_validateMinOut_revert_amount1` sends a delta of `(10,2)` and requires `(9,3)`.

## Findings
- Both tests reverted with the expected selector demonstrating branches where only one of the minima fails.
- No underlying code flaws were observed.

## Conclusion
Coverage now includes additional revert branches in `SlippageCheck.validateMinOut`, increasing confidence in slippage protections.

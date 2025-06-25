# Slippage Fee Accrual Handling

## Summary
A fuzz test verifies that calling `decreaseLiquidity` with zero liquidity and zero slippage limits succeeds even when fees have accrued. The collected delta matches fees owed.

## Methodology
1. Deploy fresh pool and PositionManager using `PosmTestSetup`.
2. Mint liquidity for an account.
3. Donate tokens to accrue fees.
4. Call `decreaseLiquidity(tokenId, 0, 0, 0, "")` via helper.
5. Assert the call does not revert and returned amounts equal `getFeesOwed`.

## Findings
- The fuzz test executed 256 runs without any revert.
- Returned deltas were equal to the fees owed for each run.

## Conclusion
✅ Current implementation properly excludes accrued fees from slippage checks when decreasing liquidity with zero slippage constraints.


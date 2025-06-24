# Slippage Bug Validation - Fees vs Deposit

## Summary
Reproduced a scenario where liquidity fees accrued exceed the token deposit required for an increase. At commit `ad04c9f`, the PositionManager subtracts fees before applying `validateMaxIn`, so slippage limits are enforced. The added regression test confirms the operation reverts with `MaximumAmountExceeded` even when fees dwarf the deposit.

## Methodology
1. Mint a position in a fresh pool.
2. Donate tokens to accrue fees larger than a subsequent deposit.
3. Attempt to increase liquidity with extremely low `amount0Max` and `amount1Max` (1 wei each).
4. Expect revert from `SlippageCheck` despite positive fees.

## Findings
- The call reverted as expected, proving slippage checks apply to the principal delta only.
- No bypass of slippage was observed at HEAD.

## Conclusion
✅ **No bug** – The current code subtracts accrued fees before validating max input, preventing fee-based slippage bypass.

## References
- Commit [`ad04c9f`](https://github.com/Uniswap/v4-periphery/commit/ad04c9f24a170accf5ea1b2836bbafd514537ca6)
- Audit reference: "Slippage Checks Are Not Enforced When Fees Accrued Exceed Tokens Required for a Liquidity Deposit."

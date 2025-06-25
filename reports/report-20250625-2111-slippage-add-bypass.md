# Slippage Check Bypass on Liquidity Increase

## Summary
We analyzed whether accrued fees allow users to bypass `validateMaxIn` when increasing liquidity. The `PositionManager` subtracts fees from the liquidity delta before calling `validateMaxIn`, ensuring the check uses the principal delta only:
```
(liquidityDelta - feesAccrued).validateMaxIn(amount0Max, amount1Max);
```
## Methodology
A dedicated test (`SlippageAddBypassTest`) mints a position, donates fees exceeding the deposit, and attempts to increase liquidity with a tight slippage limit. The call is expected to revert with `MaximumAmountExceeded`.

## Findings
Running `forge test --match-path test/SlippageAddBypass.t.sol --fuzz-runs 512` shows the revert occurs consistently, confirming slippage protection is enforced even when fees exceed the required deposit.

## Conclusion
At current HEAD the bypass described in earlier audits no longer exists. The slippage guard correctly accounts for accrued fees, preventing frontrunners from extracting value via positive principal deltas.

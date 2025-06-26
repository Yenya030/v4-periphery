# getPoolAndPositionInfo getter coverage

## Summary
Added a new test to verify `PositionManager.getPoolAndPositionInfo` returns the correct `PoolKey` and `PositionInfo` for a freshly minted position. Previous tests did not exercise this getter at all.

## Test Methodology
- Deploy a fresh pool manager and two ERC20 tokens via `PosmTestSetup`.
- Initialize a pool and deploy the `PositionManager`.
- Mint a single liquidity position and capture the resulting token ID.
- Call `getPoolAndPositionInfo` and validate all fields match the originally minted configuration.
- Ensure reported liquidity via `getPositionLiquidity` equals the minted liquidity.

## Findings
- The getter returned the correct pool data and position ticks, confirming expected behaviour.
- No bugs were uncovered; test provides missing coverage for this public view function.

## Conclusion
The new test closes a small coverage gap by exercising `getPoolAndPositionInfo`. All tests continue to pass, indicating consistent behaviour.

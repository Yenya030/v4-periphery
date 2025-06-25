# Multihop Slippage Scope

## Summary
`_swapExactInput` only verifies `amountOutMinimum` **after** all path hops. Each intermediate swap can experience arbitrary price impact as long as the final output meets the single check.

## Methodology
- Inspected `V4Router._swapExactInput` implementation.
- Noted the loop over the `PathKey` array updates `amountOut` per hop.
- Slippage check occurs once after the loop, allowing unbounded slippage in earlier pools.

## Findings
- Lines 103‑113 of `V4Router.sol` show the swap loop and the solitary check:
  ```solidity
  for (uint256 i = 0; i < pathLength; i++) {
      pathKey = params.path[i];
      (PoolKey memory poolKey, bool zeroForOne) = pathKey.getPoolAndSwapDirection(currencyIn);
      amountOut = _swap(poolKey, zeroForOne, -int256(uint256(amountIn)), pathKey.hookData).toUint128();
      amountIn = amountOut;
      currencyIn = pathKey.intermediateCurrency;
  }
  if (amountOut < params.amountOutMinimum) revert V4TooLittleReceived(params.amountOutMinimum, amountOut);
  ```
- No per-hop `amountOutMinimum` is enforced.

## Recommendation
Implement per-hop output checks (e.g., an array of `minAmountOut` for each pool) or verify that each hop's price impact stays within a user-defined tolerance.

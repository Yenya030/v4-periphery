# OPEN_DELTA Sentinel Misuse Test

## Summary
A new test ensures that passing `ActionConstants.OPEN_DELTA` (value `0`) to the router's exact input single swap uses the caller's entire credit rather than swapping zero. The router fetches the full credit via `_getFullCredit`, leading to a swap amount equal to the stored delta.

## Test Methodology
- Implemented a `RouterHarness` exposing a public `swapExactInputSingleHarness` that mirrors the router logic.
- Created a minimal `MockPoolManager` returning pre‑set deltas and capturing swap parameters.
- Set the router's credit for `token0` to `1000 ether`.
- Called `swapExactInputSingleHarness` with `amountIn = OPEN_DELTA`.

## Test Steps
1. Deploy `MockPoolManager` and `RouterHarness`.
2. Record a positive delta of `1000 ether` for `token0`.
3. Construct `ExactInputSingleParams` with `amountIn = 0`.
4. Execute the swap and verify `poolManager.lastAmountSpecified` equals `-1000 ether`.

## Findings
- The test passed: the router replaced the zero amount with the full credit. The pool manager received `-1000 ether` as the amount specified, proving a full‑balance swap occurred.

## Conclusion
The router interprets `amountIn = 0` as “use entire credit,” which could surprise callers expecting a no‑op. Interfaces should warn that zero triggers a full‑credit swap or use a non‑zero sentinel value instead.

## References
- [`V4Router._swapExactInputSingle`](src/V4Router.sol#L84-L95)
- [`ActionConstants.OPEN_DELTA`](src/libraries/ActionConstants.sol#L10)

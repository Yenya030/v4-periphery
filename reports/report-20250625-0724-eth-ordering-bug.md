# ETH Ordering Bug Investigation

## Methodology
- Attempted to initialize a pool with ETH as `currency1` using `PoolManager.initialize`.
- Used `Deployers` helpers to set up a fresh manager and created a mock ERC20 token.
- Wrote `EthOrderingBug.t.sol` which builds a `PoolKey` where `currency1` is `CurrencyLibrary.ADDRESS_ZERO`.
- Expected the call to revert and ran the test with `forge`.

## Results
- `PoolManager.initialize` reverted with `CurrenciesOutOfOrderOrEqual`, proving pools must have `currency0 < currency1`.
- Since ETH is represented by address zero, it is always `currency0` and cannot be `currency1`.

## Conclusion
- The supposed ETH-as-currency1 scenario is unachievable due to ordering checks in the core contracts.
- Therefore the router does not have a bug related to forwarding ETH for `currency1`.
- No changes are required; documentation could clarify that native ETH must be `currency0`.

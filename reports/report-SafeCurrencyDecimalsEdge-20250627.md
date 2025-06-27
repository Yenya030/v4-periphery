# SafeCurrencyMetadata Decimal Boundary Tests

This report documents additional tests for `SafeCurrencyMetadata` covering decimal boundary conditions.

## Test Methodology

The library's `currencyDecimals` function returns the decimals of a token or zero if the returned value is invalid. Existing tests covered standard and overflow cases but did not verify the boundaries at `uint8` limits.

## Test Steps

- **test_currencyDecimals_maxUint8**: Deploy a `MockToken` returning `255` for `decimals()`. Expect `currencyDecimals` to return `255`.
- **test_currencyDecimals_boundary256**: Deploy a `MockToken` returning `256` for `decimals()`. Expect a result of `0` as the value exceeds `uint8`.

## Findings

Both tests passed, confirming the library correctly handles edge values at the boundary of the `uint8` range.

## Conclusion

The new tests strengthen coverage around `currencyDecimals` by verifying behavior for the maximum valid value and the smallest overflow case.

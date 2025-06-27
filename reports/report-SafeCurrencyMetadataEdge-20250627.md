# SafeCurrencyMetadata edge cases 20250627

## Summary
Added tests for SafeCurrencyMetadata to cover cases where `symbol()` returns an empty string without reverting and when `decimals()` returns malformed short data. All tests pass and coverage improves for these paths.

## Test Methodology
- **EmptySymbolToken**: Contract that returns an empty string from `symbol()` without reverting.
- **ShortDecimalsToken**: Contract that returns 31 bytes of data from `decimals()` via inline assembly.
- Added two tests in `SafeCurrencyMetadataEdgeTest` verifying fallback behaviors.

## Test Steps
- Call `currencySymbol` on `EmptySymbolToken` expecting fallback to address-based symbol.
- Call `currencyDecimals` on `ShortDecimalsToken` expecting a return of zero due to malformed data.

## Findings
- `currencySymbol` correctly falls back when symbol is empty.
- `currencyDecimals` returns zero for malformed short data as intended.

## Conclusion
The added tests strengthen coverage of SafeCurrencyMetadata for unusual token implementations without revealing flaws. The library handles these edge cases gracefully.

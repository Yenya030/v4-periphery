# Descriptor currency color offset test

This run targeted the `currencyToColorHex` helper with an offset near the word size boundary.

## Test methodology
- Constructed a 32 byte value and shifted it by 248 bits (leaving only the highest byte).
- Called `Descriptor.currencyToColorHex` with this large offset.
- Expected a three-byte hex string padded with zeros.

## Findings
- The test passed, confirming the helper correctly handles offsets near 256 bits.

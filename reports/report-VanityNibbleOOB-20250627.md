# VanityAddressLib nibble bounds test

## Summary
Added a new unit test that ensures `VanityAddressLib.getNibble` reverts with a panic when the nibble index exceeds the 40‑nibble length of an address.

## Test Methodology
The existing edge suite did not cover out-of-bounds indices for `getNibble`. A harness contract exposes the library call and the test expects `stdError.indexOOBError` on index `40`.

## Test Steps
- Deploy `VanityAddressLibEdgeHarness` in `setUp`.
- Call `getNibble` with a sample address and index `40` while expecting a revert.
- Confirm normal nibble extraction continues to work for valid indices.

## Findings
The new test passed and triggered the expected revert, proving the library safely fails on invalid indices. No code changes were required.

## Conclusion
This test fills a small gap in `VanityAddressLibEdge` coverage by exercising the out‑of‑bounds branch of `getNibble`.

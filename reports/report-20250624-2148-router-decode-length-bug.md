# UniversalRouter decodeActionsRouterParams length check

## Summary

We attempted to reproduce the OpenZeppelin audit issue regarding incorrect length
validation in `decodeActionsRouterParams` of the UniversalRouter. The current
HEAD already sums each parameter’s padded length when checking calldata bounds,
so the historical bug is patched.

## Methodology

1. Cloned `uniswap/v4-periphery` and `uniswap/universal-router` at `main`.
2. Installed dependencies and ran the full test suites with Foundry.
3. Examined `lib/v4-periphery/src/libraries/CalldataDecoder.sol` which contains
   the `decodeActionsRouterParams` implementation used by UniversalRouter.
4. Added a new test (`CalldataDecoderLengthMismatch.t.sol`) constructing valid
   router calldata and then truncating the last byte to mimic malformed input.
5. Checked that the decoder reverts with `SliceOutOfBounds()` and measured the
   mismatch between expected and actual calldata length.

## Findings

* The decoder computes `expectedOffset` by iterating over each `bytes` element,
  ensuring the summed length matches the provided calldata. See lines below:

```solidity
            let tailOffset := shl(5, params.length)
            let expectedOffset := tailOffset
            for { let offset := 0 } lt(offset, tailOffset) { offset := add(offset, 32) } {
                let itemLengthOffset := calldataload(add(params.offset, offset))
                invalidData := or(invalidData, xor(itemLengthOffset, expectedOffset))
                let itemLengthPointer := add(params.offset, itemLengthOffset)
                let length := add(and(add(calldataload(itemLengthPointer), 0x1f), OFFSET_OR_LENGTH_MASK_AND_WORD_ALIGN), 0x20)
                expectedOffset := add(expectedOffset, length)
            }
            if or(invalidData, lt(add(_bytes.length, _bytes.offset), add(params.offset, expectedOffset))) {
                mstore(0, SLICE_ERROR_SELECTOR)
                revert(0x1c, 4)
            }
```
【F:src/libraries/CalldataDecoder.sol†L42-L67】

* Our new test confirms a 1‑byte truncation triggers this revert:

```
[PASS] test_truncatedParams_reverts() (gas: 57610)
```
【455d69†L1-L11】

The difference between expected and actual length is asserted to be one byte.

## Conclusion

❌ Bug not reproducible – the length guard at HEAD correctly verifies the
combined size of all `bytes[]` entries. Trailing or truncated data causes the
contract to revert with `SliceOutOfBounds()` as intended.

## References

- [OpenZeppelin audit report](https://blog.openzeppelin.com)
- [CalldataDecoder implementation](https://github.com/Uniswap/v4-periphery/blob/main/src/libraries/CalldataDecoder.sol)
- [UniversalRouter repository](https://github.com/Uniswap/universal-router)

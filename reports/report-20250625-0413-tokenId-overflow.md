# Token ID Overflow in PositionManager

## Summary
Using Forge's `stdstore` cheatcode we forced `nextTokenId` to `uint256.max` then minted twice. The first mint sets `nextTokenId` to `0` and the second mint reuses token ID `0`. This violates the reserved ID scheme and proves the unchecked increment can wrap.

## Methodology
1. Deployed a fresh PositionManager via `PosmTestSetup`.
2. Overwrote `nextTokenId` storage with `type(uint256).max`.
3. Minted two positions from an approved account.
4. Asserted that `nextTokenId` reset to `1` and `ownerOf(0)` returned the minter.

## Test Results
```
$ forge test -vvv --match-path test/TokenIdOverflow.t.sol
[PASS] testOverflowNextTokenId() (gas: 679595)
```

## Recommendation
Add a check before incrementing to revert if `nextTokenId` is `type(uint256).max`. This prevents wrap-around and preserves the skip-0 invariant.

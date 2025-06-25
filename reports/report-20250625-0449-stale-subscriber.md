# Stale Subscriber After Transfer

## Summary
This test attempted to verify that transferring a position via `transferFrom` or `safeTransferFrom` leaves the original subscriber mapped to the token. The expectation was that the subscriber mapping would persist and no `notifyTransfer` call would occur.

## Methodology
- Reviewed `src/base/Notifier.sol` which stores subscribers in `mapping(uint256 => ISubscriber)` without an automatic transfer hook.
- Examined `src/PositionManager.sol` where `transferFrom` overrides Solmate's implementation. It unsubscribes the position if a subscriber exists:
  ```solidity
  function transferFrom(address from, address to, uint256 id) public override onlyIfPoolManagerLocked {
      super.transferFrom(from, to, id);
      if (positionInfo[id].hasSubscriber()) _unsubscribe(id);
  }
  ```
- Wrote `test/StaleSubscriberOnTransfer.t.sol` to transfer an NFT after subscribing and check that the subscriber remains attached.

## Test Steps
1. Minted a position and subscribed a mock subscriber.
2. Called `safeTransferFrom` and `transferFrom` from the owner to another account.
3. Checked `sub.notifyTransferCount()` and `pos.subscriber(tid)` after each transfer.

## Findings
The test failed: after each transfer, `subscriber(tokenId)` returned `address(0)`, showing that the position manager automatically unsubscribes during `transferFrom`. No `notifyTransfer` callback was observed.

Forge output:
```
[FAIL] test_safeTransfer_keepsSubscriber() assertion failed
[FAIL] test_transferFrom_keepsSubscriber() assertion failed
```

## Conclusion & Recommendation
In the current repository state, transferring a position clears the subscriber mapping and does not trigger a `notifyTransfer` callback. The stale subscriber scenario described in the objective was not reproducible. If subscriber persistence is desired, remove the `_unsubscribe(id)` call in `transferFrom` and implement `notifyTransfer` logic instead.

## References
- [`src/PositionManager.sol`](../../src/PositionManager.sol) lines 536-539 show the unsubscribe logic.

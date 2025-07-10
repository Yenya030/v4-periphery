# Steal Credit Re-entrancy

This report attempts to validate a supposed vulnerability where a malicious
subscriber steals credit from the PositionManager during the `notifyModifyLiquidity`
callback.

## Summary

1. `PositionManager._modifyLiquidity` calls `_notifyModifyLiquidity` after
   calling `poolManager.modifyLiquidity`.
2. `Notifier._notifyModifyLiquidity` uses a raw `call` allowing the subscriber
to execute arbitrary code with full gas (see `Notifier._call`).
3. While the PoolManager is unlocked, the subscriber can make calls such as
   `poolManager.take`. The PoC attempts this in `RobbingSubscriber`.
4. The transaction reverts because the PoolManager tracks deltas per caller,
   so the subscriber accrues a negative delta and lock re-entry fails.

## Lines of Interest

- `PositionManager._modifyLiquidity` invokes `_notifyModifyLiquidity` before
  credit settlement【F:src/PositionManager.sol†L498-L512】.
- `Notifier._call` performs an unrestricted external call【F:src/base/Notifier.sol†L126-L132】.
- `PoolManager.take` is callable only when unlocked and mutates caller delta
  without balance checks【F:lib/v4-core/src/PoolManager.sol†L291-L305】.

## Proof of Concept

`test/StealCredit.t.sol` deploys a `RobbingSubscriber` which tries to invoke
`take` during the callback. The call reverts, confirming credit cannot be
stolen (test passes expecting a revert).

## Severity Assessment

- **Impact**: Low – the attempted exploit fails because the subscriber’s delta
  remains negative, leaving the PoolManager with open deltas and causing a
  revert.
- **Likelihood**: Low – although an external callback is available, the global
  delta invariant prevents theft.
- **Overall**: **Low (3/10)**

## Mitigation Notes

No issue confirmed; the current locking and delta accounting prevent credit
from being stolen even with re-entrant subscriber calls.

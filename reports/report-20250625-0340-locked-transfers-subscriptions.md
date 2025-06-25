# Locked-Only NFT Transfers & Subscriptions

## Summary
Calling `transferFrom`, `safeTransferFrom`, `subscribe`, or `unsubscribe` on a position NFT outside of a pool manager lock reverts with `PoolManagerMustBeLocked`. This behavior prevents normal token transfers and subscription management unless the caller is inside a locked callback.

## Methodology
- Reviewed `PositionManager` and `Notifier` implementations. Transfers and subscription functions include `onlyIfPoolManagerLocked` modifiers, reverting when the pool manager is unlocked.
- Implemented `LockedTransfersSubscriptionsTest` which unlocks the `PoolManager` and attempts each action during the callback to prove the revert.
- Fuzzed recipient and subscriber addresses over 256 runs to confirm consistent reverts.

## Test Steps
1. Deploy fresh pool manager and position manager.
2. Mint one position NFT to `alice`.
3. Unlock the pool manager with data instructing the callback to call each action.
4. Expect `PoolManagerMustBeLocked` to revert.

## Findings
- All four actions revert with `PoolManagerMustBeLocked` when executed while the pool manager is unlocked.
- Fuzzing showed no bypass; reverts were consistent.

## Impact
Users cannot transfer or manage subscriptions outside of core interactions that lock the pool. This deviates from typical ERC‑721 expectations and could trap liquidity positions unless a swap or liquidity modification is performed.

## Recommendations
- Consider allowing transfers and subscription changes when unlocked, handling subscriber cleanup in `_beforeTokenTransfer`.
- Alternatively introduce a dedicated `transferPosition` action that locks, unsubscribes, then transfers.
- Expose helpers for safe subscription updates without requiring liquidity actions.


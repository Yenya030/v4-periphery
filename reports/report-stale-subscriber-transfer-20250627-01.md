# Stale subscriber after transfer

## Summary
This report documents tests addressing subscriber state after a position token is transferred. The goal was to confirm that transferring the token clears any subscriber and causes subsequent unsubscribe calls to revert.

## Test Methodology
The existing suite lacked checks on the `hasSubscriber` flag after transfers. We added a helper that mints a position, subscribes a mock subscriber and then transfers the token. Two tests cover `safeTransferFrom` and `transferFrom`.

## Test Steps
- Mint a position and subscribe `MockTransferSubscriber`.
- Transfer the token from the original owner to a new address using `safeTransferFrom` or `transferFrom` while the pool manager is locked.
- Assert that `subscriber(tokenId)` is zero and `positionInfo(tokenId).hasSubscriber()` is false.
- Attempt to unsubscribe as the new owner and expect a `NotSubscribed` revert.

## Findings
Both tests passed, proving that transfers automatically clear the subscriber and prevent further unsubscribe attempts without a new subscription. No flaws were found.

## Conclusion
Subscriber state is correctly reset on transfers. These new tests ensure the behavior remains enforced.

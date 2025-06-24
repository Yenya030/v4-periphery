# Zero Address Deployment Checks

## Summary
These tests verify constructor arguments across multiple contracts for missing zero-address guards. Deploying each target with address(0) and exercising a privileged function consistently produced reverts, confirming misconfiguration rather than silent execution.

## Methodology
- Reviewed constructors for `ImmutableState`, `Permit2Forwarder`, and a simplified `MigratorImmutables` clone.
- Deployed each contract with zero addresses and invoked functions protected by those immutables.
- Ran fuzz tests for `MigratorImmutables` to ensure arbitrary non-zero values are handled correctly.

## Test Steps
1. **ImmutableState** – deploy with poolManager=`address(0)` and call a `onlyPoolManager` function.
2. **Permit2Forwarder** – deploy with permit2=`address(0)` and call `permit`/`permitBatch`.
3. **MigratorImmutables** – deploy with both managers=`address(0)` and call a preview function that queries v3 state.
4. Executed `forge test -vvv --match-path 'test/zero_address_*'` and `forge coverage --match-path 'test/zero_address_*'`.

## Findings
- `ImmutableState` call reverted with `NotPoolManager` as expected.
- `Permit2Forwarder` functions reverted when attempting to call `permit` on the zero address.
- `MigratorImmutables` preview reverted due to calling `ownerOf` on a non-contract.
- Fuzz test confirmed non-zero addresses are stored correctly.

## Conclusion
The constructors do not guard against zero-address deployment. Calls dependent on these immutables revert, evidencing misconfiguration. A simple `require(param != address(0))` should be added to each constructor.

## References
- [`src/base/ImmutableState.sol`](../src/base/ImmutableState.sol)
- [`src/base/Permit2Forwarder.sol`](../src/base/Permit2Forwarder.sol)
- Custom harness in [`test/zero_address_MigratorImmutables.t.sol`](../test/zero_address_MigratorImmutables.t.sol)
- Test execution output in CI logs

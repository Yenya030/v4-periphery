# BaseHook Revert Behavior - 2025-06-24

## Summary
Added targeted tests for the abstract `BaseHook` contract to ensure all unimplemented hook callbacks revert with `HookNotImplemented` and that `onlyPoolManager` access control functions correctly. Prior to this, `BaseHook` had minimal coverage.

## Test Methodology
- Inspected coverage output (`lcov.info`) and observed `src/utils/BaseHook.sol` had ~22% line coverage.
- Created a `DummyHook` inheriting `BaseHook` without overriding any hook functions. Overrode `validateHookAddress` to bypass address checks.
- Deployed `DummyHook` using a `DummyPoolManager` stub so calls could satisfy the `onlyPoolManager` modifier via `vm.prank`.

## Test Steps
- **test_onlyPoolManager**: call `beforeInitialize` from a non-manager address expecting `ImmutableState.NotPoolManager` revert.
- **test_allHooksRevert**: from the manager address call every hook callback (`beforeInitialize`, `afterInitialize`, etc.) expecting `HookNotImplemented` revert each time.

## Findings
- All hook functions correctly reverted with `HookNotImplemented` when called from the pool manager.
- Calls from other addresses reverted with `NotPoolManager` as intended.
- The full test suite now runs 518 tests with all passing.

## Conclusion
The new tests raised coverage of `BaseHook` and verified its default revert logic and access control. No functional issues were discovered. Future work might include further exercising libraries like `SVG.sol` which still show low coverage.

# BaseHook Address Validation

This report documents a new test ensuring that `BaseHook` reverts during construction when the deployed address does not match the expected permission flags.

## Test Methodology
- A `BadHook` contract extending `BaseHook` returns permissions that set the `BEFORE_INITIALIZE` flag.
- Using `HookMiner.computeAddress`, the test calculates a CREATE2 address which does **not** match these flags.
- Deploying `BadHook` at this address must revert with `Hooks.HookAddressNotValid`.

## Test Steps
- Predict address for the chosen salt.
- Ensure its lower 14 bits differ from the desired flag.
- Expect revert and attempt deployment with the same salt.

## Findings
- Deployment fails as expected, confirming the validation logic rejects mismatched addresses.

## Conclusion
The added test covers a revert path previously untested in `BaseHook`, improving confidence in hook deployment safety.

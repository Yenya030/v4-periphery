# HookMiner computeAddress Coverage

## Summary
Added a unit test verifying that `HookMiner.computeAddress` matches OpenZeppelin's `Create2.computeAddress` formula.

## Test Methodology
- Constructed bytecode using `MockBlankHook` creation code with constructor arguments.
- Called `HookMiner.computeAddress` and compared it with `Create2.computeAddress` using the same deployer and salt.

## Test Steps
1. Build bytecode with constructor parameters.
2. Compute expected address using `Create2.computeAddress`.
3. Assert `HookMiner.computeAddress` returns the same address.

## Findings
- The new test passed, confirming the correctness of `HookMiner.computeAddress`.

## Conclusion
This test adds explicit coverage for `HookMiner`'s `computeAddress` helper which previously lacked direct verification.

# HookMiner computeAddress determinism

## Summary
This report adds a regression test ensuring that repeated calls to `HookMiner.computeAddress` with identical inputs produce the same address. The goal is to guard against accidental non-determinism in future changes.

## Methodology
- Examined existing tests and noticed no direct check that `computeAddress` is deterministic.
- Created a new test contract `HookMinerDeterministicTest` that calls `computeAddress` twice with the same parameters and compares the results.

## Test Steps
- Deploy `HookMinerDeterministicTest`.
- Call `test_computeAddress_deterministic` which computes two addresses using the same deployer, salt, and bytecode.
- Assert equality of the returned addresses.

## Findings
- The new test passes, confirming deterministic behaviour.

## Conclusion
`HookMiner.computeAddress` is deterministic as expected. The added test protects against regressions.

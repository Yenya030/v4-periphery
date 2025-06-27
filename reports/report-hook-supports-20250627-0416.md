# Hook support flags coverage

## Summary
Added tests to verify that token wrapper hooks expose correct support flags for exact input/output swaps.

## Test Methodology
- Created harness contracts overriding `validateHookAddress` to allow direct deployment and exposing `_supportsExactInput` and `_supportsExactOutput`.
- WETHHook harness checks default behavior; WstETHHook harness checks override.

## Test Steps
- Deploy harness hooks in tests.
- Call `supportsExactInput` and `supportsExactOutput` and assert expected booleans.

## Findings
- WETHHook supports both exact input and exact output.
- WstETHHook only supports exact input as expected.

## Conclusion
New tests confirm hook support flags behave as designed, covering internal methods previously untested.

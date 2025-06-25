# Locker Default State Test

## Summary
Added a small test confirming that `Locker.get()` returns the zero address when no locker has been set.

## Methodology
The new unit test instantiates a `LockerHarness` and immediately calls `getLocker()` without calling `setLocker` first.

## Test Steps
- Deploy `LockerHarness`.
- Invoke `getLocker()` before any call to `setLocker`.
- Assert the returned address is `address(0)`.

## Findings
The test passed, verifying that the library's transient storage slot is empty by default.

## Conclusion
`Locker.get()` correctly returns the zero address prior to initialization. This guards against unexpected non-zero values when using the library for the first time.

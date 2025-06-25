# NativeWrapper Wrap/Unwrap Tests

## Summary
Added tests for `NativeWrapper` ensuring the helper functions `_wrap` and `_unwrap` correctly convert ETH to WETH and vice versa. Both paths were previously untested.

## Methodology
- Identified that `NativeWrapper.t.sol` only checked the `receive` function. 
- Added two tests calling the harness `wrap` and `unwrap` functions directly and verifying token and ETH balances change as expected.

## Test Steps
- `test_wrap_deposits_weth` sends 1 ETH to the wrapper and checks the wrapper's WETH balance increases by 1 ETH after wrapping.
- `test_unwrap_withdraws_weth` deposits 2 ETH then unwraps 1 ETH, verifying the wrapper's WETH balance decreases and ETH balance increases.

## Findings
- Both new tests pass showing the contract handles direct wrapping and unwrapping correctly. No issues were observed.

## Conclusion
The additional tests cover previously untouched code in `NativeWrapper`, increasing assurance that wrapping and unwrapping behave as intended.

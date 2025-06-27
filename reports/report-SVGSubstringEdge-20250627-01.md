# SVG substring edge cases

This report adds tests for `SVG.substring` to verify that out-of-bounds access or invalid indices revert as expected. Two new tests use a harness exposing the substring logic. They assert reverts with `stdError.indexOOBError` when the end index exceeds the input length and with `stdError.arithmeticError` when the start index is greater than the end index. Coverage slightly improved by exercising these revert paths.

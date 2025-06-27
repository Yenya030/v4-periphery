# UniswapV4DeployerCompetition initialization test

## Summary
Added a focused unit test verifying that `exclusiveDeployDeadline` is derived correctly from the constructor arguments of `UniswapV4DeployerCompetition`.

## Methodology
- Ran the full Forge suite to establish a baseline (663 passing tests).
- Reviewed coverage reports and noticed that the initial value of `exclusiveDeployDeadline` had no direct assertion.
- Created `UniswapV4DeployerCompetitionInitTest` with a single assertion of the deadline calculation and deployer address.

## Test Steps
- Deploy `UniswapV4DeployerCompetition` with a known competition deadline and exclusive period.
- Assert that `exclusiveDeployDeadline()` equals `competitionDeadline + exclusiveDeployLength`.
- Assert that the deployer address is stored correctly.

## Findings
- The new test passed and the entire suite remained green, confirming the constructor logic works as expected.

## Conclusion
Constructor parameters for `UniswapV4DeployerCompetition` are handled correctly. This small gap in initialization checks is now covered.

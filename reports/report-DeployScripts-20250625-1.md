# Deployment Scripts Coverage

## Summary
This report documents additional tests written to exercise the deployment helper scripts within the periphery repository. These scripts previously had zero coverage.

## Test Methodology
- Reviewed coverage output and found `script/DeployPosm.s.sol`, `DeployStateView.s.sol`, and `DeployV4Quoter.s.sol` reporting 0% coverage.
- Created a dedicated test contract `DeployScriptsTest` that instantiates each script contract and invokes its `run` function using dummy addresses.
- Verified that the returned contract instances reference the supplied `poolManager` address.

## Test Steps
- **test_runDeployPosm**: calls `DeployPosmTest.run` with constant parameters and asserts that the created `PositionManager` and `PositionDescriptor` report the provided pool manager.
- **test_runDeployStateView**: calls `DeployStateView.run` and checks the deployed `StateView`.
- **test_runDeployV4Quoter**: calls `DeployV4Quoter.run` and validates the resulting `V4Quoter`.

## Findings
- All new tests passed, confirming the scripts deploy contracts correctly when called from solidity.
- No logic flaws were found; however, the added tests raise coverage of these scripts from 0%.

## Conclusion
The deployment scripts now have direct unit tests confirming their runtime behavior. While no defects were discovered, the repository gains broader coverage of previously untested code paths.

# Codex Agent Guidelines

This repository does not previously include an AGENTS.md file. The following instructions summarize the contribution guidelines for Codex agents.

## Repository Overview
- Solidity contracts for the Uniswap v4 periphery.
- Uses [foundry](https://book.getfoundry.sh/) for compilation and testing.

## Required Steps for Code Changes
1. **Formatting**: Run `forge fmt` before committing to ensure standard formatting.
2. **Testing**: Execute `forge test` and `forge snapshot` to run the test suite and update gas snapshots.
3. **Documentation**: Document public functions and interfaces using natspec comments.
4. **Naming**: Follow Solidity style guidelines. Internal functions and variables should use the `_prependUnderscore` style.
5. **Commit Hygiene**: Squash commits where possible to keep history clean. PRs are squashed into a single commit when merged.

## Additional Notes
- The CI workflows run `forge fmt --check` and `forge test --isolate -vvv`, so ensure tests pass locally.
- Be respectful in issues and pull requests. Spam or disrespectful content may be closed.


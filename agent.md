# AGENTS.md
## Mission
For every Solidity file **added or modified** in the current branch under /src exclude /src/test:
1. Recompile contracts (`forge build`).
2. Run `python tools/promfuzz/scripts/gen_invariants.py --file $FILE --out invariant_templates/`.
3. Update `promfuzz.yaml` so `contracts:` includes the new artefact path.
4. Run `npm test` (or `forge test`); abort on failure.
5. Commit only files under `invariant_templates/` and `promfuzz.yaml`; open a PR.

## Constraints
* **Never** call `promfuzz run` or use outbound network.
* Do not touch `.env`, `out/`, or secrets.
* Time budget: 25 min.
* If tests fail, revert all changes and exit with status 1.

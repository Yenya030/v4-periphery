# Native Notifier Coverage Extension

This report documents adding tests for notifier flows on native pools and low level SVG curve generation.

## Methodology
- Ran the full test suite with `forge test -vvv`.
- Identified missing coverage for `generageSvgCurve` via code inspection.
- Noticed TODO for native pool key coverage in `PositionManager.notifier.t.sol`.
- Added `SVGCurveTest` to exercise curve rendering.
- Added `NotifierNativeTest` to cover subscribe, modify liquidity and unsubscribe on a native pool.

## Findings
- `SVGCurveTest` verifies `generageSvgCurve` output for an in-range position.
- `NotifierNativeTest` ensures notifications fire correctly when using a pool where `currency0` is the native token.

No functional issues were uncovered.

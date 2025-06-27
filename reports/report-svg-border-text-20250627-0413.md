# SVG border text generation coverage

## Summary
Added a new unit test for the SVG library to ensure the `generateSVGBorderText` logic embeds the provided currency information. The test uses a new harness exposing the border text helper.

## Methodology
- Inspected coverage reports produced by `forge coverage`. `SVG.sol` showed about 52% coverage with no tests around the border text helper.
- Implemented `generateSVGBorderTextExternal` in `SVGHarness` to invoke the logic.
- Wrote `SVGBorderTextTest` validating that output strings contain the passed currency names and symbols.

## Steps
- Ran `forge test` to ensure the full suite passes with the new test.
- Ran `forge coverage --report summary` to confirm coverage metrics.

## Findings
- The new test passed and confirmed the helper correctly embeds the parameters.
- Overall coverage slightly improved with an additional executed file.

## Conclusion
Testing confirmed the border text generation behaves as intended when given simple input values. No flaws were discovered, but coverage for `SVG.sol` increased marginally.

pragma solidity ^0.8.24;

import {SVG} from "../../src/libraries/SVG.sol";
import {Strings} from "openzeppelin-contracts/contracts/utils/Strings.sol";
import {BitMath} from "@uniswap/v4-core/src/libraries/BitMath.sol";

contract SVGHarness {
    using Strings for uint256;

    function tickToString(int24 tick) external pure returns (string memory) {
        string memory sign = "";
        if (tick < 0) {
            tick = tick * -1;
            sign = "-";
        }
        return string(abi.encodePacked(sign, uint256(uint24(tick)).toString()));
    }

    function generateSVGRareSparkle(uint256 tokenId, address hooks) external pure returns (string memory) {
        if (isRare(tokenId, hooks)) {
            return string(
                abi.encodePacked(
                    '<g style="transform:translate(226px, 392px)"><rect width="36px" height="36px" rx="8px" ry="8px" fill="none" stroke="rgba(255,255,255,0.2)" />',
                    '<g><path style="transform:translate(6px,6px)" d="M12 0L12.6522 9.56587L18 1.6077L13.7819 10.2181L22.3923 6L14.4341 ',
                    "11.3478L24 12L14.4341 12.6522L22.3923 18L13.7819 13.7819L18 22.3923L12.6522 14.4341L12 24L11.3478 14.4341L6 22.3923",
                    'L10.2181 13.7819L1.6077 18L9.56587 12.6522L0 12L9.56587 11.3478L1.6077 6L10.2181 10.2181L6 1.6077L11.3478 9.56587L12 0Z" fill="white" />',
                    '<animateTransform attributeName="transform" type="rotate" from="0 18 18" to="360 18 18" dur="10s" repeatCount="indefinite"/></g></g>'
                )
            );
        }
        return "";
    }

    function substringExternal(string memory str, uint256 startIndex, uint256 endIndex)
        external
        pure
        returns (string memory)
    {
        bytes memory strBytes = bytes(str);
        bytes memory result = new bytes(endIndex - startIndex);
        for (uint256 i = startIndex; i < endIndex; i++) {
            result[i - startIndex] = strBytes[i];
        }
        return string(result);
    }

    function isRare(uint256 tokenId, address hooks) public pure returns (bool) {
        bytes32 h = keccak256(abi.encodePacked(tokenId, hooks));
        return uint256(h) < type(uint256).max / (1 + BitMath.mostSignificantBit(tokenId) * 2);
    }

    function generateSVGBorderTextExternal(
        string memory quoteCurrency,
        string memory baseCurrency,
        string memory quoteCurrencySymbol,
        string memory baseCurrencySymbol
    ) external pure returns (string memory svg) {
        svg = string(
            abi.encodePacked(
                '<text text-rendering="optimizeSpeed">',
                '<textPath startOffset="-100%" fill="white" font-family="\'Courier New\', monospace" font-size="10px" xlink:href="#text-path-a">',
                baseCurrency,
                unicode" • ",
                baseCurrencySymbol,
                ' <animate additive="sum" attributeName="startOffset" from="0%" to="100%" begin="0s" dur="30s" repeatCount="indefinite" />',
                '</textPath> <textPath startOffset="0%" fill="white" font-family="\'Courier New\', monospace" font-size="10px" xlink:href="#text-path-a">',
                baseCurrency,
                unicode" • ",
                baseCurrencySymbol,
                ' <animate additive="sum" attributeName="startOffset" from="0%" to="100%" begin="0s" dur="30s" repeatCount="indefinite" /> </textPath>'
            )
        );
        svg = string(
            abi.encodePacked(
                svg,
                '<textPath startOffset="50%" fill="white" font-family="\'Courier New\', monospace" font-size="10px" xlink:href="#text-path-a">',
                quoteCurrency,
                unicode" • ",
                quoteCurrencySymbol,
                ' <animate additive="sum" attributeName="startOffset" from="0%" to="100%" begin="0s" dur="30s" repeatCount="indefinite" /></textPath><textPath startOffset="-50%" fill="white" font-family="\'Courier New\', monospace" font-size="10px" xlink:href="#text-path-a">',
                quoteCurrency,
                unicode" • ",
                quoteCurrencySymbol,
                ' <animate additive="sum" attributeName="startOffset" from="0%" to="100%" begin="0s" dur="30s" repeatCount="indefinite" /></textPath></text>'
            )
        );
    }

    function generateSVGCardMantleExternal(
        string memory quoteCurrencySymbol,
        string memory baseCurrencySymbol,
        string memory feeTier
    ) external pure returns (string memory svg) {
        svg = string(
            abi.encodePacked(
                '<g mask="url(#fade-symbol)"><rect fill="none" x="0px" y="0px" width="290px" height="200px" /> <text y="70px" x="32px" fill="white" font-family="\'Courier New\', monospace" font-weight="200" font-size="36px">',
                quoteCurrencySymbol,
                '/',
                baseCurrencySymbol,
                '</text><text y="115px" x="32px" fill="white" font-family="\'Courier New\', monospace" font-weight="200" font-size="36px">',
                feeTier,
                "</text></g>",
                '<rect x="16" y="16" width="258" height="468" rx="26" ry="26" fill="rgba(0,0,0,0)" stroke="rgba(255,255,255,0.2)" />'
            )
        );
    }
}

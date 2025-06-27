// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MockLongSymbol {
    function symbol() external pure returns (string memory) {
        return "ABCDEFGHIJKLM"; // 13 chars
    }

    function decimals() external pure returns (uint8) {
        return 18;
    }
}

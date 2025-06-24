// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MockBytes32Symbol {
    function symbol() external pure returns (bytes32) {
        return bytes32("BYTES32SYM");
    }
    function decimals() external pure returns (uint8) {
        return 18;
    }
}

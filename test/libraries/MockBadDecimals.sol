// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MockBadDecimals {
    function decimals() external pure returns (uint256) {
        return 300;
    }
}

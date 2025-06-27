// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Base64} from "./base64.sol";

contract DecodeCaller {
    function callDecode(string memory s) external pure returns (bytes memory) {
        return Base64.decode(s);
    }
}

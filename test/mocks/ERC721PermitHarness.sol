// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721Permit_v4} from "../../src/base/ERC721Permit_v4.sol";

contract ERC721PermitHarness is ERC721Permit_v4 {
    constructor(string memory name_, string memory symbol_) ERC721Permit_v4(name_, symbol_) {}

    function exposed_isApprovedOrOwner(address spender, uint256 tokenId) external view returns (bool) {
        return _isApprovedOrOwner(spender, tokenId);
    }

    function mint(address to) external returns (uint256 tokenId) {
        tokenId = ++lastTokenId;
        _mint(to, tokenId);
    }

    uint256 public lastTokenId;

    function tokenURI(uint256) public pure override returns (string memory) {
        return "";
    }
}

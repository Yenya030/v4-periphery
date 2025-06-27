pragma solidity ^0.8.20;

import {ERC721Permit_v4} from "../../src/base/ERC721Permit_v4.sol";

contract MockERC721PermitHarness is ERC721Permit_v4 {
    uint256 public lastTokenId;

    constructor(string memory name, string memory symbol) ERC721Permit_v4(name, symbol) {}

    function mint() external returns (uint256 tokenId) {
        tokenId = ++lastTokenId;
        _mint(msg.sender, tokenId);
    }

    function tokenURI(uint256) public pure override returns (string memory) {
        return "mock";
    }

    function isApprovedOrOwner(address spender, uint256 tokenId) external view returns (bool) {
        return _isApprovedOrOwner(spender, tokenId);
    }
}

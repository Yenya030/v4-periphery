// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {MockERC721PermitHarness} from "../harness/MockERC721PermitHarness.sol";

contract ERC721PermitIsApprovedTest is Test {
    MockERC721PermitHarness token;
    address bob = address(0xB0B);

    function setUp() public {
        token = new MockERC721PermitHarness("Mock", "MOCK");
    }

    function test_isApprovedOrOwner_owner() public {
        uint256 tokenId = token.mint();
        assertTrue(token.isApprovedOrOwner(address(this), tokenId));
    }

    function test_isApprovedOrOwner_approved() public {
        uint256 tokenId = token.mint();
        token.approve(bob, tokenId);
        assertTrue(token.isApprovedOrOwner(bob, tokenId));
    }

    function test_isApprovedOrOwner_unapproved() public {
        uint256 tokenId = token.mint();
        assertFalse(token.isApprovedOrOwner(bob, tokenId));
    }
}

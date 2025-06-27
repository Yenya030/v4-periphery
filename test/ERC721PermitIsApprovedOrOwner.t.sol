// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {ERC721PermitHarness} from "./mocks/ERC721PermitHarness.sol";

contract ERC721PermitIsApprovedOrOwnerTest is Test {
    ERC721PermitHarness token;
    address alice = address(0x1);
    address bob = address(0x2);
    address operator = address(0x3);

    function setUp() public {
        token = new ERC721PermitHarness("name","SYM");
    }

    function test_owner_isApprovedOrOwner_true() public {
        uint256 id = token.mint(alice);
        vm.prank(alice);
        assertTrue(token.exposed_isApprovedOrOwner(alice, id));
    }

    function test_approved_isApprovedOrOwner_true() public {
        uint256 id = token.mint(alice);
        vm.prank(alice);
        token.approve(bob, id);
        assertTrue(token.exposed_isApprovedOrOwner(bob, id));
    }

    function test_operator_isApprovedOrOwner_true() public {
        uint256 id = token.mint(alice);
        vm.prank(alice);
        token.setApprovalForAll(operator, true);
        assertTrue(token.exposed_isApprovedOrOwner(operator, id));
    }

    function test_unapproved_isApprovedOrOwner_false() public {
        uint256 id = token.mint(alice);
        assertFalse(token.exposed_isApprovedOrOwner(bob, id));
    }
}

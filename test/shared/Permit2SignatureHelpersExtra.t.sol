// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {Permit2SignatureHelpers} from "./Permit2SignatureHelpers.sol";
import {IAllowanceTransfer} from "permit2/src/interfaces/IAllowanceTransfer.sol";

contract Permit2SignatureHelpersExtraTest is Test, Permit2SignatureHelpers {
    function test_getCompactPermitSignature_roundtrip() public {
        bytes32 domain = bytes32(uint256(0x1234));
        IAllowanceTransfer.PermitSingle memory permit = defaultERC20PermitAllowance(address(1), 100, 1, 0);
        uint256 pk = 0x12341234;
        bytes memory compact = getCompactPermitSignature(permit, pk, domain);
        (uint8 v, bytes32 r, bytes32 s) = getPermitSignatureRaw(permit, pk, domain);
        (bytes32 r2, bytes32 vs) = _getCompactSignature(v, r, s);
        bytes memory expected = bytes.concat(r2, vs);
        assertEq(compact, expected);
        assertEq(compact.length, 64);
    }
}

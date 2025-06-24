// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {Permit2Forwarder} from "../src/base/Permit2Forwarder.sol";
import {IAllowanceTransfer} from "permit2/src/interfaces/IAllowanceTransfer.sol";

contract ZeroAddressPermit2ForwarderTest is Test {
    Permit2Forwarder forwarder;

    function setUp() public {
        forwarder = new Permit2Forwarder(IAllowanceTransfer(address(0)));
    }

    function test_permit_reverts() public {
        IAllowanceTransfer.PermitSingle memory permit;
        vm.expectRevert();
        forwarder.permit(address(this), permit, "");
    }

    function test_permitBatch_reverts() public {
        IAllowanceTransfer.PermitBatch memory permit;
        vm.expectRevert();
        forwarder.permitBatch(address(this), permit, "");
    }
}

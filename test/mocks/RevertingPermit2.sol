// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import {IAllowanceTransfer} from "permit2/src/interfaces/IAllowanceTransfer.sol";

contract RevertingPermit2 is IAllowanceTransfer {
    function DOMAIN_SEPARATOR() external pure returns (bytes32) {
        return bytes32(0);
    }
    function allowance(address, address, address) external pure override returns (uint160, uint48, uint48) {
        return (0,0,0);
    }
    function approve(address, address, uint160, uint48) external pure override {}
    function permit(address, PermitSingle memory, bytes calldata) external pure override {
        revert("mock revert");
    }
    function permit(address, PermitBatch memory, bytes calldata) external pure override {
        revert("mock revert");
    }
    function transferFrom(address, address, uint160, address) external pure override {}
    function transferFrom(AllowanceTransferDetails[] calldata) external pure override {}
    function lockdown(TokenSpenderPair[] calldata) external pure override {}
    function invalidateNonces(address, address, uint48) external pure override {}
}

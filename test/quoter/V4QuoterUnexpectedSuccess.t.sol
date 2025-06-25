// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {V4Quoter} from "../../src/lens/V4Quoter.sol";
import {BaseV4Quoter} from "../../src/base/BaseV4Quoter.sol";
import {IPoolManager} from "@uniswap/v4-core/src/interfaces/IPoolManager.sol";

contract DummyPoolManager {
    function callUnlock(address quoter, bytes calldata data) external returns (bytes memory) {
        return V4Quoter(quoter).unlockCallback(data);
    }
}

contract V4QuoterUnexpectedSuccessTest is Test {
    V4Quoter quoter;
    DummyPoolManager manager;

    function setUp() public {
        manager = new DummyPoolManager();
        quoter = new V4Quoter(IPoolManager(address(manager)));
    }

    function test_unlockCallback_unexpectedSuccess() public {
        bytes memory data = abi.encodeCall(quoter.msgSender, ());
        vm.expectRevert(BaseV4Quoter.UnexpectedCallSuccess.selector);
        manager.callUnlock(address(quoter), data);
    }
}

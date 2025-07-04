// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {IPoolManager} from "@uniswap/v4-core/src/interfaces/IPoolManager.sol";
import {NativeWrapper} from "../../src/base/NativeWrapper.sol";
import {ImmutableState} from "../../src/base/ImmutableState.sol";
import {IWETH9} from "../../src/interfaces/external/IWETH9.sol";
import {WETH} from "solmate/src/tokens/WETH.sol";

contract ForceSend {
    constructor() payable {}

    function attack(address target) external {
        selfdestruct(payable(target));
    }
}

contract MockPoolManager {}

contract NativeWrapperHarness is NativeWrapper {
    constructor(IWETH9 _weth9, IPoolManager _pm) ImmutableState(_pm) NativeWrapper(_weth9) {}
}

contract NativeWrapperForceSendTest is Test {
    NativeWrapperHarness wrapper;
    WETH weth;
    MockPoolManager pm;

    function setUp() public {
        weth = new WETH();
        pm = new MockPoolManager();
        wrapper = new NativeWrapperHarness(IWETH9(address(weth)), IPoolManager(address(pm)));
    }

    function test_force_send_eth_via_selfdestruct() public {
        ForceSend fs = new ForceSend{value: 1 ether}();
        fs.attack(address(wrapper));
        assertEq(address(wrapper).balance, 1 ether);
    }
}

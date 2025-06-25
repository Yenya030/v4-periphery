// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {IPoolManager} from "@uniswap/v4-core/src/interfaces/IPoolManager.sol";
import {NativeWrapper} from "../src/base/NativeWrapper.sol";
import {ImmutableState} from "../src/base/ImmutableState.sol";
import {IWETH9} from "../src/interfaces/external/IWETH9.sol";
import {WETH} from "solmate/src/tokens/WETH.sol";

contract MockPoolManager {
    function sendEther(address payable to) external payable {
        to.transfer(msg.value);
    }
}

contract NativeWrapperHarness is NativeWrapper {
    constructor(IWETH9 _weth9, IPoolManager _poolManager)
        ImmutableState(_poolManager)
        NativeWrapper(_weth9)
    {}

    function wrap(uint256 amount) external payable {
        _wrap(amount);
    }

    function unwrap(uint256 amount) external {
        _unwrap(amount);
    }
}

contract NativeWrapperTest is Test {
    NativeWrapperHarness wrapper;
    MockPoolManager manager;
    WETH weth;

    function setUp() public {
        weth = new WETH();
        manager = new MockPoolManager();
        wrapper = new NativeWrapperHarness(IWETH9(address(weth)), IPoolManager(address(manager)));
    }

    function test_receive_reverts_for_unknown_sender() public {
        vm.deal(address(this), 1 ether);
        vm.expectRevert(NativeWrapper.InvalidEthSender.selector);
        address(wrapper).call{value: 1 ether}("");
    }

    function test_receive_from_WETH9_succeeds() public {
        vm.deal(address(this), 1 ether);
        weth.deposit{value: 1 ether}();
        weth.transfer(address(wrapper), 1 ether);
        wrapper.unwrap(1 ether);
    }

    function test_receive_from_poolManager_succeeds() public {
        vm.deal(address(manager), 1 ether);
        manager.sendEther{value: 1 ether}(payable(address(wrapper)));
    }

    function test_wrap_deposits_weth() public {
        vm.deal(address(this), 1 ether);
        uint256 beforeWeth = weth.balanceOf(address(wrapper));
        wrapper.wrap{value: 1 ether}(1 ether);
        assertEq(weth.balanceOf(address(wrapper)) - beforeWeth, 1 ether);
    }

    function test_unwrap_withdraws_weth() public {
        vm.deal(address(this), 2 ether);
        wrapper.wrap{value: 2 ether}(2 ether);
        uint256 beforeWeth = weth.balanceOf(address(wrapper));
        uint256 beforeEth = address(wrapper).balance;
        wrapper.unwrap(1 ether);
        assertEq(beforeWeth - weth.balanceOf(address(wrapper)), 1 ether);
        assertEq(address(wrapper).balance - beforeEth, 1 ether);
    }
}

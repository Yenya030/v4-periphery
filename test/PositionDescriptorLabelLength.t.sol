// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {Deployers} from "@uniswap/v4-core/test/utils/Deployers.sol";
import {Deploy} from "./shared/Deploy.sol";
import {IPositionDescriptor} from "../src/interfaces/IPositionDescriptor.sol";
import {IWETH9} from "../src/interfaces/external/IWETH9.sol";
import {WETH} from "solmate/src/tokens/WETH.sol";

contract PositionDescriptorLabelLengthTest is Test, Deployers {
    IPositionDescriptor descriptor;
    IWETH9 weth;

    string constant LONG_LABEL = "12345678901234567890123456789012";
    bytes32 constant LONG_LABEL_BYTES = 0x3132333435363738393031323334353637383930313233343536373839303132;

    function setUp() public {
        deployFreshManager();
        weth = IWETH9(address(new WETH()));
        descriptor = Deploy.positionDescriptor(address(manager), address(weth), LONG_LABEL_BYTES, hex"00");
    }

    function test_nativeCurrencyLabel_32bytes() public {
        assertEq(descriptor.nativeCurrencyLabel(), LONG_LABEL);
    }
}

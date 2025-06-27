pragma solidity ^0.8.24;

import {Descriptor} from "../../src/libraries/Descriptor.sol";

contract DescriptorHarness {
    function generateSVGImageExternal(Descriptor.ConstructTokenURIParams memory params) external pure returns (string memory) {
        return Descriptor.generateSVGImage(params);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";

interface INonfungiblePositionManagerMinimal {
    function ownerOf(uint256 tokenId) external view returns (address);
}

interface IPositionManagerMinimal {}

struct MigratorParameters {
    address v3PositionManager;
    address v4PositionManager;
}

contract MigratorImmutables {
    INonfungiblePositionManagerMinimal public immutable V3_POSITION_MANAGER;
    IPositionManagerMinimal public immutable V4_POSITION_MANAGER;

    constructor(MigratorParameters memory params) {
        V3_POSITION_MANAGER = INonfungiblePositionManagerMinimal(params.v3PositionManager);
        V4_POSITION_MANAGER = IPositionManagerMinimal(params.v4PositionManager);
    }
}

contract MigratorImmutablesHarness is MigratorImmutables {
    constructor(address v3, address v4)
        MigratorImmutables(MigratorParameters({v3PositionManager: v3, v4PositionManager: v4}))
    {}

    function preview(uint256 tokenId) external view returns (address) {
        return V3_POSITION_MANAGER.ownerOf(tokenId);
    }
}

contract ZeroAddressMigratorImmutablesTest is Test {
    MigratorImmutablesHarness migrator;

    function setUp() public {
        migrator = new MigratorImmutablesHarness(address(0), address(0));
    }

    function test_preview_reverts_with_zero_addresses() public {
        vm.expectRevert();
        migrator.preview(1);
    }

    function test_fuzz_non_zero(address v3, address v4) public {
        vm.assume(v3 != address(0) && v4 != address(0));
        MigratorImmutablesHarness m = new MigratorImmutablesHarness(v3, v4);
        assertEq(address(m.V3_POSITION_MANAGER()), v3);
        assertEq(address(m.V4_POSITION_MANAGER()), v4);
    }
}

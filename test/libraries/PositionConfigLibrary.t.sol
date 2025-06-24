// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import {Currency} from "@uniswap/v4-core/src/types/Currency.sol";
import {PoolKey} from "@uniswap/v4-core/src/types/PoolKey.sol";
import {IHooks} from "@uniswap/v4-core/src/interfaces/IHooks.sol";

import {PositionConfig, PositionConfigLibrary} from "../../src/libraries/PositionConfig.sol";
import {PositionConfigId, PositionConfigIdLibrary} from "../../src/libraries/PositionConfigId.sol";
import {PathKey, PathKeyLibrary} from "../../src/libraries/PathKey.sol";
import {AddressStringUtil} from "../../src/libraries/AddressStringUtil.sol";

contract PositionConfigLibraryTest is Test {
    function _calcId(PositionConfig calldata config) external pure returns (bytes32) {
        return PositionConfigLibrary.toId(config);
    }

    function test_toId_matches_hash() public {
        PositionConfig memory config = PositionConfig({
            poolKey: PoolKey({
                currency0: Currency.wrap(address(0x1111111111111111111111111111111111111111)),
                currency1: Currency.wrap(address(0x2222222222222222222222222222222222222222)),
                fee: 500,
                tickSpacing: 60,
                hooks: IHooks(address(0))
            }),
            tickLower: -120,
            tickUpper: 120
        });

        bytes32 result = this._calcId(config);
        bytes32 expected = keccak256(
            abi.encodePacked(
                config.poolKey.currency0,
                config.poolKey.currency1,
                config.poolKey.fee,
                config.poolKey.tickSpacing,
                config.poolKey.hooks,
                config.tickLower,
                config.tickUpper
            )
        ) >> 1;

        assertEq(result, expected);
    }
}

contract PositionConfigIdLibraryTest is Test {
    using PositionConfigIdLibrary for PositionConfigId;

    PositionConfigId internal cfg;

    function test_subscribe_flow() public {
        bytes32 id = bytes32(uint256(12345));
        cfg.setConfigId(id);
        assertEq(cfg.getConfigId(), id);
        assertFalse(cfg.hasSubscriber());
        cfg.setSubscribe();
        assertTrue(cfg.hasSubscriber());
        assertEq(cfg.getConfigId(), id); // high bit ignored
        cfg.setUnsubscribe();
        assertFalse(cfg.hasSubscriber());
        assertEq(cfg.getConfigId(), id);
    }
}

contract PathKeyLibraryTest is Test {
    function _call(PathKey calldata p, Currency c) external pure returns (PoolKey memory, bool) {
        return PathKeyLibrary.getPoolAndSwapDirection(p, c);
    }

    function test_getPoolAndSwapDirection_forward() public {
        Currency inCurrency = Currency.wrap(address(0x1111));
        Currency outCurrency = Currency.wrap(address(0x2222));
        PathKey memory path = PathKey(outCurrency, 3000, 60, IHooks(address(0)), bytes(""));
        (PoolKey memory pool, bool zeroForOne) = this._call(path, inCurrency);

        assertTrue(zeroForOne);
        assertEq(Currency.unwrap(pool.currency0), Currency.unwrap(inCurrency));
        assertEq(Currency.unwrap(pool.currency1), Currency.unwrap(outCurrency));
        assertEq(pool.fee, 3000);
        assertEq(pool.tickSpacing, 60);
        assertEq(address(pool.hooks), address(0));
    }

    function test_getPoolAndSwapDirection_reverse() public {
        Currency inCurrency = Currency.wrap(address(0x2222));
        Currency outCurrency = Currency.wrap(address(0x1111));
        PathKey memory path = PathKey(outCurrency, 3000, 60, IHooks(address(0)), bytes(""));
        (PoolKey memory pool, bool zeroForOne) = this._call(path, inCurrency);

        assertFalse(zeroForOne);
        assertEq(Currency.unwrap(pool.currency0), Currency.unwrap(outCurrency));
        assertEq(Currency.unwrap(pool.currency1), Currency.unwrap(inCurrency));
    }

    function test_getPoolAndSwapDirection_equalCurrencies() public {
        Currency token = Currency.wrap(address(0x1234));
        PathKey memory path = PathKey(token, 3000, 60, IHooks(address(0)), bytes(""));
        (PoolKey memory pool, bool zeroForOne) = this._call(path, token);

        assertFalse(zeroForOne);
        assertEq(Currency.unwrap(pool.currency0), Currency.unwrap(token));
        assertEq(Currency.unwrap(pool.currency1), Currency.unwrap(token));
    }
}

contract AddressStringUtilTest is Test {
    function charRef(uint8 v) internal pure returns (bytes1 c) {
        return v < 10 ? bytes1(v + 0x30) : bytes1(v + 0x37);
    }

    function _call(address a, uint256 len) external pure {
        AddressStringUtil.toAsciiString(a, len);
    }

    function test_invalid_length() public {
        vm.expectRevert(abi.encodeWithSelector(AddressStringUtil.InvalidAddressLength.selector, 41));
        this._call(address(0), 41);
    }

    function test_toAsciiString_full() public {
        address addr = 0x1234567890AbcdEF1234567890aBcdef12345678;
        string memory s = AddressStringUtil.toAsciiString(addr, 40);
        bytes memory b = bytes(s);
        assertEq(b.length, 40);

        uint256 num = uint256(uint160(addr));
        for (uint256 i = 0; i < 20; i++) {
            uint8 byteVal = uint8(num >> (8 * (19 - i)));
            assertEq(b[2 * i], charRef(byteVal >> 4));
            assertEq(b[2 * i + 1], charRef(byteVal & 0xf));
        }
    }
}

pragma solidity ^0.8.24;

import {MockERC20} from "solmate/src/test/utils/mocks/MockERC20.sol";
import {IWstETH} from "../../src/interfaces/external/IWstETH.sol";

/// @title Mock Variable Rate Wrapped Staked ETH
/// @notice wstETH mock with adjustable exchange rate for testing
contract MockVariableWstETH is MockERC20, IWstETH {
    address public immutable stETHToken;
    uint256 public exchangeRate; // stETH per wstETH with 18 decimals

    constructor(address _stETH, uint256 _rate) MockERC20("Wrapped Staked ETH", "wstETH", 18) {
        stETHToken = _stETH;
        exchangeRate = _rate;
    }

    function setExchangeRate(uint256 _rate) external {
        exchangeRate = _rate;
    }

    function wrap(uint256 _stETHAmount) external returns (uint256) {
        MockERC20(stETHToken).transferFrom(msg.sender, address(this), _stETHAmount);
        uint256 wstAmount = getWstETHByStETH(_stETHAmount);
        _mint(msg.sender, wstAmount);
        return wstAmount;
    }

    function unwrap(uint256 _wstETHAmount) external returns (uint256) {
        _burn(msg.sender, _wstETHAmount);
        uint256 stAmount = getStETHByWstETH(_wstETHAmount);
        MockERC20(stETHToken).transfer(msg.sender, stAmount);
        return stAmount;
    }

    function getWstETHByStETH(uint256 _stETHAmount) public view returns (uint256) {
        if (_stETHAmount == 0) return 0;
        return (_stETHAmount * 1e18) / exchangeRate;
    }

    function getStETHByWstETH(uint256 _wstETHAmount) public view returns (uint256) {
        if (_wstETHAmount == 0) return 0;
        return (_wstETHAmount * exchangeRate) / 1e18;
    }

    function stEthPerToken() external view returns (uint256) {
        return exchangeRate;
    }

    function tokensPerStEth() external view returns (uint256) {
        return 1e36 / exchangeRate;
    }

    function stETH() external view returns (address) {
        return stETHToken;
    }
}

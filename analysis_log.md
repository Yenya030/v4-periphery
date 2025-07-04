# PROMFUZZ Analysis Log

## Stage 1: Auditor's Report

**Potential Issue Found:**
- **Matching Subcategory:** Non-AMM Price Oracle Manipulation
- **Relevant Code Snippet(s):**
```solidity
function _getWrapInputRequired(uint256 wrappedAmount) internal view override returns (uint256) {
    return wrappedAmount.divWadUp(wstETH.tokensPerStEth());
}
```

**Potential Issue Found:**
- **Matching Subcategory:** Unauthorized Transfer
- **Relevant Code Snippet(s):**
```solidity
function _sweep(Currency currency, address to) internal {
    uint256 balance = currency.balanceOfSelf();
    if (balance > 0) currency.transfer(to, balance);
}
```

**Potential Issue Found:**
- **Matching Subcategory:** Wrong Checkpoint Order
- **Relevant Code Snippet(s):**
```solidity
function _mapWrapUnwrapAmount(Currency inputCurrency, uint256 amount, Currency outputCurrency)
    internal
    view
    returns (uint256)
{
    uint256 balance = inputCurrency.balanceOf(address(this));
    if (amount == ActionConstants.CONTRACT_BALANCE) {
        return balance;
    }
    if (amount == ActionConstants.OPEN_DELTA) {
        amount = _getFullDebt(outputCurrency);
    }
    if (amount > balance) revert InsufficientBalance();
    return amount;
}
```

**Potential Issue Found:**
- **Matching Subcategory:** Improper Handling of the Deposit Fee
- **Relevant Code Snippet(s):**
```solidity
constructor(IPoolManager _manager, address payable _weth)
    BaseTokenWrapperHook(
        _manager,
        Currency.wrap(_weth),
        CurrencyLibrary.ADDRESS_ZERO
    )
{}
```
```solidity
if (poolKey.fee != 0) revert InvalidPoolFee();
```

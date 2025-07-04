# PROMFUZZ Analysis Log

## Stage 1: Auditor's Report

> **Potential Issue Found:**
> - **Matching Subcategory:** AMM Price Oracle Manipulation
> - **Relevant Code Snippet(s):**
> ```solidity
> (uint160 sqrtPriceX96,,,) = poolManager.getSlot0(poolKey.toId());
> liquidity = LiquidityAmounts.getLiquidityForAmounts(
>     sqrtPriceX96,
>     TickMath.getSqrtPriceAtTick(info.tickLower()),
>     TickMath.getSqrtPriceAtTick(info.tickUpper()),
>     _getFullCredit(poolKey.currency0),
>     _getFullCredit(poolKey.currency1)
> );
> ```
> The liquidity amount is derived from the current pool price retrieved via `getSlot0`. If the price can be manipulated right before this call, the calculated liquidity could be skewed.
>
> **Potential Issue Found:**
> - **Matching Subcategory:** Non-AMM Price Oracle Manipulation
> - **Relevant Code Snippet(s):**
> ```solidity
> function _getWrapInputRequired(uint256 wrappedAmount) internal view override returns (uint256) {
>     return wrappedAmount.divWadUp(wstETH.tokensPerStEth());
> }
> ```
> The hook relies on `wstETH.tokensPerStEth()` to compute required amounts. If that external rate is manipulated, wrapping calculations could be affected.
>
> **Potential Issue Found:**
> - **Matching Subcategory:** Approval Not Clear
> - **Relevant Code Snippet(s):**
> ```solidity
> function permit(address spender, uint256 tokenId, uint256 deadline, uint256 nonce, bytes calldata signature)
>     external payable checkSignatureDeadline(deadline)
> {
>     address owner = _ownerOf[tokenId];
>     bytes32 digest = ERC721PermitHash.hashPermit(spender, tokenId, nonce, deadline);
>     signature.verify(_hashTypedData(digest), owner);
>     _useUnorderedNonce(owner, nonce);
>     _approve(owner, spender, tokenId);
> }
> ```
> Permit approvals interact with internal `_approve` without additional checks on spender or revocation semantics, which could lead to confusion about outstanding approvals.
>
> **Potential Issue Found:**
> - **Matching Subcategory:** Unauthorized Transfer
> - **Relevant Code Snippet(s):**
> ```solidity
> function transferFrom(address from, address to, uint256 id) public virtual override onlyIfPoolManagerLocked {
>     super.transferFrom(from, to, id);
>     if (positionInfo[id].hasSubscriber()) _unsubscribe(id);
> }
> ```
> Transfers are allowed when the PoolManager is locked but rely on external approval checks in the parent contract. Any flaw in `_isApprovedOrOwner` could allow unintended token movements.
>
> **Potential Issue Found:**
> - **Matching Subcategory:** Wrong Checkpoint Order
> - **Relevant Code Snippet(s):**
> ```solidity
> function _settle(Currency currency, address payer, uint256 amount) internal {
>     if (amount == 0) return;
>     poolManager.sync(currency);
>     if (currency.isAddressZero()) {
>         poolManager.settle{value: amount}();
>     } else {
>         _pay(currency, payer, amount);
>         poolManager.settle();
>     }
> }
> ```
> Syncing and settling occur before token transfers in some branches, which may lead to stale balance calculations if external tokens are manipulated.
>
> **Potential Issue Found:**
> - **Matching Subcategory:** Risky First Deposit
> - **Relevant Code Snippet(s):**
> ```solidity
> constructor(IPoolManager _manager, IWstETH _wsteth)
>     BaseTokenWrapperHook(
>         _manager,
>         Currency.wrap(address(_wsteth)),
>         Currency.wrap(_wsteth.stETH())
>     )
> {
>     wstETH = _wsteth;
>     ERC20(Currency.unwrap(underlyingCurrency)).safeApprove(address(wstETH), type(uint256).max);
> }
> ```
> The hook sets an unlimited approval for stETH in the constructor, potentially giving the deployer or first caller undue influence if the wstETH contract behaves unexpectedly.
>
> **Potential Issue Found:**
> - **Matching Subcategory:** Improper Handling of the Deposit Fee
> - **Relevant Code Snippet(s):**
> ```solidity
> function _beforeInitialize(address, PoolKey calldata poolKey, uint160) internal view override returns (bytes4) {
>     bool isValidPair = wrapZeroForOne
>         ? (poolKey.currency0 == underlyingCurrency && poolKey.currency1 == wrapperCurrency)
>         : (poolKey.currency0 == wrapperCurrency && poolKey.currency1 == underlyingCurrency);
>     if (!isValidPair) revert InvalidPoolToken();
>     if (poolKey.fee != 0) revert InvalidPoolFee();
>     return IHooks.beforeInitialize.selector;
> }
> ```
> Wrapper pools enforce zero fee during initialization. Any misconfiguration here could allow incorrect fees to be applied or bypassed.
>
> **Potential Issue Found:**
> - **Matching Subcategory:** Wrong Implementation of Amount Lock
> - **Relevant Code Snippet(s):**
> ```solidity
> modifier onlyIfPoolManagerLocked() override {
>     if (poolManager.isUnlocked()) revert PoolManagerMustBeLocked();
>     _;
> }
> ```
> Functions guarded by this modifier depend on external PoolManager state. If the lock status is toggled unexpectedly, funds could be manipulated before the action completes.
>
> **Potential Issue Found:**
> - **Matching Subcategory:** Vote Manipulation
> - **Relevant Code Snippet(s):**
> *(No direct voting mechanism identified in the current codebase. However, if hooks or external subscribers were granted voting privileges via callbacks, flash loans might be used to manipulate decisions.)*
>

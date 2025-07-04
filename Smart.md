## Tier 1: Context and Critical Points

### PositionDescriptor.sol
#### Transactional Context:
Generates metadata for position NFTs, pulling pool information and formatting it into a JSON data URI.
#### Critical Program Points:
- `tokenURI` reads pool and position info and constructs metadata lines 52-95.
- `flipRatio` and `currencyRatioPriority` control how currencies are ordered lines 98-126.
- Immutable variables `poolManager`, `wrappedNative` define core addresses lines 28-33.

### PositionManager.sol
#### Transactional Context:
ERC721 contract that mints and manages liquidity position NFTs. Handles minting, liquidity modification, burns, and settlement with the PoolManager.
#### Critical Program Points:
- State variables `nextTokenId`, `positionInfo`, and `poolKeys` store positions lines 119-126.
- `_handleAction` dispatches action codes to liquidity, settlement, or swap operations lines 195-283.
- Internal functions `_increase`, `_decrease`, `_mint`, `_burn` perform poolManager.modifyLiquidity and require approval lines 286-439.
- Settlement helpers `_settle`, `_take`, `_close`, `_clearOrTake` manage token balances lines 442-480.

### UniswapV4DeployerCompetition.sol
#### Transactional Context:
Crowdsources salts to deploy the Uniswap V4 PoolManager at a vanity address. Tracks best salt and allows deployment after competition ends.
#### Critical Program Points:
- Variables `bestAddressSalt`, `bestAddressSubmitter`, `competitionDeadline`, `initCodeHash`, `deployer`, `exclusiveDeployDeadline` lines 13-27.
- `updateBestAddress` validates salts and stores the best candidate lines 41-59.
- `deploy` enforces deadlines and creates the PoolManager via `Create2` lines 62-78.

### V4Router.sol
#### Transactional Context:
Abstract router executing batch actions such as swaps and settlement via the PoolManager. Meant for integrations to route tokens through pools.
#### Critical Program Points:
- `_handleAction` parses encoded actions and routes to swap or payment logic lines 32-79.
- Swap helpers `_swapExactInputSingle`, `_swapExactInput`, `_swapExactOutputSingle`, `_swapExactOutput` lines 82-154.
- Low-level `_swap` performs poolManager.swap and returns delta lines 156-171.

### base/BaseActionsRouter.sol
#### Transactional Context:
Utility base that decodes action calldata and ensures only PoolManager can call back. Provides mapping helpers for recipients and payers.
#### Critical Program Points:
- `_executeActions` triggers poolManager.unlock with provided data lines 23-26.
- `_unlockCallback` decodes actions and delegates to `_handleAction` lines 29-37.
- Recipient mapping `_mapRecipient` and `_mapPayer` used by inheriting routers lines 60-74.

### base/BaseV4Quoter.sol
#### Transactional Context:
Base quoting logic for simulating swaps via PoolManager and extracting quote amounts from reverts.
#### Critical Program Points:
- Modifier `selfOnly` restricts internal simulation calls lines 22-27.
- `_unlockCallback` catches revert data and bubbles it to caller lines 29-35.
- `_swap` executes poolManager.swap and checks liquidity lines 37-58.

### base/DeltaResolver.sol
#### Transactional Context:
Abstract helper for settling or taking token deltas with the PoolManager, used by routers and hooks.
#### Critical Program Points:
- `_take` and `_settle` move funds between contract and PoolManager lines 22-47.
- `_getFullDebt` and `_getFullCredit` read transient currency deltas lines 57-76.
- `_mapWrapUnwrapAmount` ensures balance checks for wrapping operations lines 98-122.

### base/EIP712_v4.sol
#### Transactional Context:
Provides a chain-specific EIP-712 domain and hashing helper used by permit-enabled contracts.
#### Critical Program Points:
- Immutable cached DOMAIN_SEPARATOR components lines 14-24.
- `DOMAIN_SEPARATOR()` and `_hashTypedData` compute typed data hashes lines 28-55.

### base/ERC721Permit_v4.sol
#### Transactional Context:
Extends ERC721 with permit functionality via EIP712 signatures and unordered nonces.
#### Critical Program Points:
- `permit` and `permitForAll` verify signatures and set approvals lines 26-56.
- `_approve`, `_approveForAll`, and `_isApprovedOrOwner` govern token permissions lines 69-97.

### base/ImmutableState.sol
#### Transactional Context:
Holds the immutable PoolManager address and restricts certain functions to only be callable by it.
#### Critical Program Points:
- Immutable variable `poolManager` defined in constructor lines 12-23.
- `onlyPoolManager` modifier used across the project lines 17-21.

### base/Multicall_v4.sol
#### Transactional Context:
Utility allowing multiple method calls in a single transaction using delegatecall.
#### Critical Program Points:
- `multicall` loops over provided calldata, bubbling up revert reasons lines 8-24.

### base/NativeWrapper.sol
#### Transactional Context:
Provides wrapping/unwrapping of ETH via WETH9 for use in routers and hooks.
#### Critical Program Points:
- Immutable `WETH9` address set in constructor lines 12-19.
- `_wrap` and `_unwrap` handle depositing or withdrawing WETH lines 20-27.
- `receive` restricts unexpected ETH senders line 28-33.

### base/Notifier.sol
#### Transactional Context:
Allows position NFTs to optionally notify external subscriber contracts on transfers or liquidity changes.
#### Critical Program Points:
- Mapping `subscriber` and immutable `unsubscribeGasLimit` lines 17-21.
- `subscribe` and `_unsubscribe` manage subscriber lifecycle and callouts lines 22-63.
- `_notifyModifyLiquidity` and `_removeSubscriberAndNotifyBurn` send callbacks lines 90-120.

### base/Permit2Forwarder.sol
#### Transactional Context:
Forwarder that submits ERC20 Permit2 approvals for users before executing other router actions.
#### Critical Program Points:
- Immutable `permit2` reference set in constructor lines 12-17.
- `permit` and `permitBatch` execute permits via try/catch to avoid reverts lines 19-33.

### base/PoolInitializer_v4.sol
#### Transactional Context:
Helper for initializing pools with an initial price and returning the resulting tick.
#### Critical Program Points:
- `initializePool` wraps poolManager.initialize and returns tick or sentinel value lines 12-20.

### base/ReentrancyLock.sol
#### Transactional Context:
Uses transient storage to lock execution and store the locker address, preventing reentrancy.
#### Critical Program Points:
- Modifier `isNotLocked` sets and clears locker around function execution lines 9-15.
- `_getLocker` exposes current locker address line 17-19.

### base/SafeCallback.sol
#### Transactional Context:
Ensures only the PoolManager can call unlockCallback and delegates logic to implementer.
#### Critical Program Points:
- `unlockCallback` applies `onlyPoolManager` and forwards data to `_unlockCallback` lines 12-19.

### base/UnorderedNonce.sol
#### Transactional Context:
Manages bitmapped nonces for signatures to prevent replay attacks.
#### Critical Program Points:
- Mapping `nonces` stores used bits lines 10-12.
- `_useUnorderedNonce` checks and flips nonce bits lines 15-23.
- `revokeNonce` exposes nonce consumption externally lines 24-27.

### base/hooks/BaseTokenWrapperHook.sol
#### Transactional Context:
Abstract hook that wraps or unwraps tokens when swaps occur, managing a wrapper/underlying pair.
#### Critical Program Points:
- Immutable currencies and `wrapZeroForOne` orientation set in constructor lines 45-66.
- `_beforeInitialize` validates pools and fees lines 88-102.
- `_beforeSwap` performs wrapping/unwrapping and returns swap delta lines 115-149.
- Abstract `_deposit` and `_withdraw` for implementers lines 160-184.

### hooks/WETHHook.sol
#### Transactional Context:
Concrete token wrapper hook converting between ETH and WETH at 1:1 ratio.
#### Critical Program Points:
- `_deposit` deposits ETH to WETH and settles to PoolManager lines 31-39.
- `_withdraw` withdraws WETH back to ETH lines 42-49.

### hooks/WstETHHook.sol
#### Transactional Context:
Wrapper hook converting between stETH and wstETH with dynamic exchange rate.
#### Critical Program Points:
- Constructor sets wstETH and approves stETH unlimited lines 23-36.
- `_deposit` wraps stETH via wstETH and settles to PoolManager lines 38-51.
- `_withdraw` unwraps wstETH lines 54-63.
- Exchange rate helpers `_getWrapInputRequired` and `_getUnwrapInputRequired` lines 65-81.

### lens/StateView.sol
#### Transactional Context:
Read-only wrapper exposing PoolManager state getters for off-chain clients.
#### Critical Program Points:
- Exposes slot0, tick info, liquidity and position queries lines 18-41 and onwards.

### lens/V4Quoter.sol
#### Transactional Context:
Provides external quote functions that simulate swaps through PoolManager and return amounts and gas estimates.
#### Critical Program Points:
- `quoteExactInputSingle`, `quoteExactInput`, `quoteExactOutputSingle`, `quoteExactOutput` run simulations via poolManager.unlock lines 31-88.
- Internal `_quoteExactInput`, `_quoteExactOutput` and single-hop variants compute deltas lines 91-151.
## Tier 2: Inferred Invariants

### PositionDescriptor.sol
- **`tokenURI`**
  - `require(position exists && poolManager != address(0))`
  - `assert(bytes(jsonURI).length > 0)`
  - `assert(poolManager == Old(poolManager))`
- **`flipRatio` and `currencyRatioPriority`**
  - `require(currency0 != currency1)`
  - `assert(returned ratio ordering stable)`
- **Immutable Variables**
  - `assert(poolManager != address(0))`
  - `assert(wrappedNative != address(0))`

### PositionManager.sol
- **State Variables**
  - `assert(nextTokenId == Old(nextTokenId) + 1)` when minting
  - `assert(positionInfo[tokenId].owner == msg.sender)` after minting
- **`_handleAction`**
  - `require(valid action code)`
  - `assert(positionInfo updated according to action)`
- **Internal Liquidity Functions**
  - `require(_isApprovedOrOwner(msg.sender, tokenId))`
  - `assert(liquidity after == Old(liquidity) ± delta)`
- **Settlement Helpers**
  - `require(amounts >= 0)`
  - `assert(token balances reflect settled amounts)`

### UniswapV4DeployerCompetition.sol
- **State Variables**
  - `assert(competitionDeadline < exclusiveDeployDeadline)`
- **`updateBestAddress`**
  - `require(block.timestamp < competitionDeadline)`
  - `assert(bestAddressSalt == candidateSalt || Old(bestAddressSalt) < candidateSalt)`
- **`deploy`**
  - `require(block.timestamp >= competitionDeadline)`
  - `assert(deployedAddress == predictedAddress)`

### V4Router.sol
- **`_handleAction`**
  - `require(actions.length > 0)`
  - `assert(all actions executed)`
- **Swap Helpers**
  - `require(amountIn > 0)`
  - `assert(amountOut >= 0)`
- **`_swap`**
  - `require(poolKey.valid)`
  - `assert(delta balances consistent with swap)`

### base/BaseActionsRouter.sol
- **`_executeActions`**
  - `assert(poolManager.unlock called once)`
- **`_unlockCallback`**
  - `require(msg.sender == poolManager)`
  - `assert(actions decoded correctly)`
- **Recipient Mapping**
  - `require(recipient != address(0))`

### base/BaseV4Quoter.sol
- **Modifier `selfOnly`**
  - `require(msg.sender == address(this))`
- **`_unlockCallback`**
  - `require(msg.sender == poolManager)`
  - `assert(revert data bubbled)`
- **`_swap`**
  - `require(liquidity > 0)`
  - `assert(returned delta != 0)`

### base/DeltaResolver.sol
- **`_take` and `_settle`**
  - `require(available balance >= amount)`
  - `assert(poolManager balances updated)`
- **`_getFullDebt` and `_getFullCredit`**
  - `assert(values reflect latest deltas)`
- **`_mapWrapUnwrapAmount`**
  - `require(amount > 0)`
  - `assert(final balance >= 0)`

### base/EIP712_v4.sol
- **DOMAIN_SEPARATOR Components**
  - `assert(chainId != 0)`
- **`DOMAIN_SEPARATOR()` and `_hashTypedData`**
  - `assert(hash != bytes32(0))`

### base/ERC721Permit_v4.sol
- **`permit` and `permitForAll`**
  - `require(valid signature)`
  - `assert(approval set)`
- **Approval Helpers**
  - `require(_isApprovedOrOwner(msg.sender, tokenId))`
  - `assert(approval mappings updated)`

### base/ImmutableState.sol
- **Immutable `poolManager`**
  - `assert(poolManager != address(0))`
- **`onlyPoolManager`**
  - `require(msg.sender == poolManager)`

### base/Multicall_v4.sol
- **`multicall`**
  - `require(data.length > 0)`
  - `assert(calls executed in order)`

### base/NativeWrapper.sol
- **Immutable `WETH9`**
  - `assert(WETH9 != address(0))`
- **`_wrap` and `_unwrap`**
  - `require(amount > 0)`
  - `assert(token balances changed by amount)`
- **`receive`**
  - `require(msg.sender == WETH9)`

### base/Notifier.sol
- **Subscriber Mapping**
  - `assert(subscriber[tokenId] != address(0) || unsubscribed)`
- **`subscribe` / `_unsubscribe`**
  - `require(msg.sender == owner)`
  - `assert(subscription state updated)`
- **Notification Hooks**
  - `require(gasleft() >= unsubscribeGasLimit)`
  - `assert(callback executed or skipped)`

### base/Permit2Forwarder.sol
- **Immutable `permit2`**
  - `assert(permit2 != address(0))`
- **`permit` and `permitBatch`**
  - `require(permitted signatures)`
  - `assert(allowances set)`

### base/PoolInitializer_v4.sol
- **`initializePool`**
  - `require(pool not initialized)`
  - `assert(return tick != type(int24).max)`

### base/ReentrancyLock.sol
- **`isNotLocked`**
  - `require(_getLocker() == address(0))`
  - `assert(_getLocker() == address(0))` after
- **`_getLocker`**
  - `assert(return != address(0) || not locked)`

### base/SafeCallback.sol
- **`unlockCallback`**
  - `require(msg.sender == poolManager)`
  - `assert(_unlockCallback executed)`

### base/UnorderedNonce.sol
- **Nonce Mapping**
  - `assert(!nonces[owner][nonce])`
- **`_useUnorderedNonce`**
  - `require(!nonces[owner][nonce])`
  - `assert(nonces[owner][nonce])`
- **`revokeNonce`**
  - `require(msg.sender == owner)`
  - `assert(nonces[owner][nonce])`

### base/hooks/BaseTokenWrapperHook.sol
- **Constructor**
  - `require(currencyIn != currencyOut)`
  - `assert(wrapZeroForOne == (currencyIn < currencyOut))`
- **`_beforeInitialize`**
  - `require(fee <= maxFee)`
  - `assert(pool validated)`
- **`_beforeSwap`**
  - `require(amount > 0)`
  - `assert(delta == deposit - withdraw)`
- **`_deposit` / `_withdraw`**
  - `require(amount > 0)`
  - `assert(tokens moved correctly)`

### hooks/WETHHook.sol
- **`_deposit`**
  - `require(msg.value >= amount)`
  - `assert(WETH balance increased by amount)`
- **`_withdraw`**
  - `require(WETH balance >= amount)`
  - `assert(ETH sent == amount)`

### hooks/WstETHHook.sol
- **Constructor**
  - `require(address(wstETH) != address(0))`
  - `assert(stETH allowance == type(uint256).max)`
- **`_deposit`**
  - `require(amount > 0)`
  - `assert(wstETH minted >= amount)`
- **`_withdraw`**
  - `require(wstETH balance >= amount)`
  - `assert(stETH received >= amount)`
- **Exchange Rate Helpers**
  - `assert(value derived from current rate)`

### lens/StateView.sol
- **Read Functions**
  - `assert(no state changes)`

### lens/V4Quoter.sol
- **Quote Functions**
  - `require(inputAmount > 0)`
  - `assert(outputAmount >= 0)`
- **Internal Quote Helpers**
  - `assert(reverts capture gas estimate)`


## Tier 3: Vulnerability Report & Exploits

### Vulnerability: Pool Reinitialization Bypass
**Violated Invariant:** `initializePool` should require the pool is not already initialized and assert the returned tick is not `type(int24).max`.
**Attack Path:**
1. Initialize a new pool normally.
2. Call `initializePool` again with the same `PoolKey`.
3. The internal `poolManager.initialize` reverts and the catch block returns `type(int24).max`.
4. The invariant expecting a non‐sentinel tick is violated.
**PoC Sketch (Foundry):**
```solidity
function test_reinitPool() public {
    poolInitializer.initializePool(key, price); // first init succeeds
    int24 result = poolInitializer.initializePool(key, price); // second init
    assertEq(result, type(int24).max); // invariant broken
}
```

### Vulnerability: Forced Ether Injection via Selfdestruct
**Violated Invariant:** `NativeWrapper.receive` enforces `msg.sender == WETH9`.
**Attack Path:**
1. Deploy a helper contract holding ETH.
2. Selfdestruct the helper with `selfdestruct(nativeWrapperAddr)`.
3. ETH is forcibly sent without invoking `receive`, bypassing the sender check.
4. The NativeWrapper now holds ETH from an unauthorized source, violating the invariant.
**PoC Sketch (Foundry):**
```solidity
contract ForceSend {
    constructor() payable {}
    function attack(address target) external {
        selfdestruct(payable(target));
    }
}
```
## Tier 3: Vulnerability Report & Exploits

### Vulnerability: Forced Ether Injection
**Violated Invariant:** `receive` requires `msg.sender == WETH9` in `NativeWrapper.sol`.
**Attack Path:** An attacker deploys a temporary contract holding ETH and invokes `selfdestruct(target)` with `target` set to the wrapper contract. The forced transfer bypasses the `receive` check because `selfdestruct` does not trigger the `receive` function. The wrapper's ETH balance becomes larger than expected without passing through `_wrap`, breaking assumptions about token balance changes.
**PoC Sketch (Foundry/Hardhat):**
```solidity
contract ForceSend {
    function attack(address target) external payable {
        selfdestruct(payable(target));
    }
}
```

### Vulnerability: Flash Loan Rate Manipulation
**Violated Invariant:** `_deposit` in `WstETHHook.sol` asserts `wstETH minted >= amount`.
**Attack Path:** Using flash loans, an attacker rapidly mints or burns wstETH around a call to `_beforeSwap` so the exchange rate changes between the deposit and settle steps. The wrapper receives fewer wstETH than expected, violating the invariant that the minted amount covers the deposit.
**PoC Sketch (Foundry/Hardhat):**
```solidity
function testManipulateRate() public {
    // borrow large stETH, wrap to wstETH altering exchange rate
    flashLoan(stETH, hugeAmount);
    wstETH.wrap(hugeAmount);
    // call hook during manipulated rate window
    vm.prank(attacker);
    hook.beforeSwap(...);
}
```
## Tier 3: Vulnerability Report & Exploits

### Vulnerability: Reentrant Unlock via Malicious Hook
**Violated Invariant:** BaseActionsRouter.sol - `_executeActions` - `assert(poolManager.unlock called once)`
**Attack Path:**
1. Deploy a custom hook contract that calls the router again from its callback.
2. User invokes `BaseActionsRouter._executeActions` with an action that triggers the hook.
3. During `poolManager.unlock`, the hook's callback reenters `_executeActions`, causing a second `unlock` call before the first finishes.
4. Nested unlocks allow multiple modifications and violate the invariant that the pool manager is unlocked only once per call.
**PoC Sketch (Foundry/Hardhat):**
```solidity
function testReentrantUnlock() public {
    bytes memory actions = abi.encodePacked(uint8(Actions.SWAP_EXACT_IN));
    bytes[] memory params = new bytes[](1);
    params[0] = abi.encode(swapParams); // crafted swap to trigger hook
    router.executeActions(actions, params); // hook reenters here
    // expect state corruption or double unlock
}
```

### Vulnerability: Rounding Attack on wstETH Hook
**Violated Invariant:** BaseTokenWrapperHook.sol - `_beforeSwap` - `assert(delta == deposit - withdraw)`
**Attack Path:**
1. Borrow a minimal amount of stETH via flash loan.
2. Call the wstETH hook to wrap this amount where `wstETH.wrap` rounds down to zero.
3. The hook records a deposit of 1 wei stETH but zero wstETH minted.
4. The swap delta becomes zero while the deposit was non-zero, breaking the expected equality.
**PoC Sketch (Foundry/Hardhat):**
```solidity
function testRoundingExploit() public {
    uint256 tinyAmount = 1; // 1 wei stETH
    deal(address(stETH), address(hook), tinyAmount);
    hook.swapExactIn(tinyAmount); // delta becomes 0 due to rounding
    // assert that delta != tinyAmount
}
```

### Vulnerability: Gas Griefing on Notifier
**Violated Invariant:** Notifier.sol - Notification Hooks - `require(gasleft() >= unsubscribeGasLimit)` and `assert(callback executed or skipped)`
**Attack Path:**
1. Deploy a subscriber contract whose `notifyUnsubscribe` consumes all provided gas and reverts.
2. Subscribe this contract to a position.
3. Call `unsubscribe` with exactly `unsubscribeGasLimit` gas so the pre-check passes.
4. The subscriber reverts, consuming gas and leaving the position locked until a new transaction succeeds, violating the expectation that the callback completes or is skipped.
**PoC Sketch (Foundry/Hardhat):**
```solidity
function testGasGriefUnsubscribe() public {
    GriefSubscriber sub = new GriefSubscriber();
    positionManager.subscribe(tokenId, address(sub), "");
    vm.prank(user, user, unsubscribeGas);
    positionManager.unsubscribe(tokenId); // reverts due to gas exhaustion
}
```
## Tier 3: Vulnerability Report & Exploits

### Vulnerability: Forced ETH Injection via Selfdestruct
**Violated Invariant:** base/NativeWrapper.sol `receive` - `require(msg.sender == WETH9)`
**Attack Path:** An attacker deploys a helper contract funded with ETH. This helper contract self-destructs to the NativeWrapper address. Because `selfdestruct` transfers ETH without calling `receive`, the `msg.sender` check is bypassed and ETH is forcibly sent to the contract, violating the assumption that only WETH9 can send ETH.
**PoC Sketch (Foundry):**
```solidity
contract ForceSend {
    constructor() payable {}
    function attack(address target) external {
        selfdestruct(payable(target));
    }
}
```
Deploy `ForceSend` with ETH and call `attack(NativeWrapper)`.

### Vulnerability: Reentrancy Triggering Multiple Unlocks
**Violated Invariant:** base/BaseActionsRouter.sol `_executeActions` - `assert(poolManager.unlock called once)`
**Attack Path:** A malicious subscriber or hook contracts uses its callback during `poolManager.unlock` to invoke the router again. This nested call leads to a second `poolManager.unlock` execution in the same transaction, breaking the invariant and potentially corrupting router state.
**PoC Sketch (Foundry):**
```solidity
contract MalHook is ISubscriber {
    BaseActionsRouter router;
    bytes data;
    constructor(BaseActionsRouter _router, bytes memory _data) {router = _router; data = _data;}
    function notifySubscribe(uint256, bytes calldata) external {}
    function notifyUnsubscribe(uint256) external {}
    function notifyModifyLiquidity(uint256, int256, BalanceDelta) external {
        router._executeActions(data); // reenter while unlock in progress
    }
    function notifyBurn(uint256, address, PositionInfo calldata, uint256, BalanceDelta calldata) external {}
}
```
Register `MalHook` as a subscriber and trigger a liquidity change to demonstrate reentrancy.

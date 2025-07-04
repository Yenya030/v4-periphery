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

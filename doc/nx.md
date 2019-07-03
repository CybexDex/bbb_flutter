# QA

Ticker Price:

```json
{
	"px": 7937.84,
	"sym": ".BXBT",
	"xts": 1560235225248000,
	"time": "2019-06-11T06:40:27.265086Z"
}
```

Contract:

```json
{
	"contractId": "NBTC6200X070100",
	"assetName": "NXC.NBTCAA",
	"underlying": ".BXBT", //name
	"conversionRate": "0.001",
	"startGearing": "5.0", //Initial leverage when contract is created. As time passes, actual leverage is changed.
	"tradingStartTime": "1559347200",
	"tradingStopTime": "1561852800",
	"expiration": "1561939200",
	"availableInventory": "10000.0", //剩余份数
	"tickSize": "0.001",  // Contract price minimum tick size
	"commissionRate": "0.002", //px
	"quoteAsset": "NXC.USDT",
	"status": "ACTIVE",//NOT_STARTED READY_TO_START ACTIVE TRADING_STOP SETTLED KNOCKED_OUT TRADING_HALT UNWIND_ONLY DELISTED EXCEPTION
	"strikeLevel": "6200.0",
	"knockOutTime": "0", //Time when strike price is hit
	"settlementUnderlyingPrice": "0.0",
	"settlementPrice": "0.0",//Contract price when contract is settled or knocked out
	"modificationTime": "1557280860"
}
```

Order:

```json
{
	"accountName": "abigale1989", //Username
	"status": "OPEN", // value could be: OPEN/CLOSED/REJECTED
	"buyOrderTxId": "61106ad41e18ac18f0c3b9e2464ed23cb3cbf9f1", // NxOrder's buyOrderTxId
	"contractId": "NBTC6400X061300", // The contract bought by user. The full contract description can be found in refData
	"underlyingSpotPx": "8000.0", // Underlying price when user places order. The actual price will be provided in "boughtPx".
	"cutLossPx": "6600.0", // The latest cutLossPx which set by NxOrder or NxAmend
	"takeProfitPx": "9000.0", // The latest takeProfitPx which set by NxOrder or NxAmend
	"expiration": "1970-01-19T00:49:00.000000Z", // The latest expiration time which set by NxOrder or NxAmend
	"qtyContract": "10.0", // The contract amount bought by NxOrder
	"commission": "0.16", // The commission deducted in NXC.USDT
	"boughtPx": "7800.0", // The underlying price when NxOrder is processed
	"boughtContractPx": "1.4", // Contract price when NxOrder is processed
	"boughtNotional": "14.0", // NXC.USDT paid for the contact
	"soldPx": "0.0", // The underlying price when NxOrder is settled
	"soldContractPx": "0.0", // The contract price when NxOrder is settled
	"soldNotional": "0.0", // NXC.USDT received after settled
	"closeReason": "", // Text reason for close. E.g. Knocked out, contract expired
	"settleTime": "", // Time when order is settled
	"createTime": "1970-01-19T00:47:37.000000Z", // Time of NxOrder creation
	"lastUpdateTime": "2019-05-17T01:50:58.210357Z", // Last update time
	"details": "Order price is not able to match existing price: NBTC6200X070100 current price:1.471 request price: 1.44"
}
```

Fund
```json
{
    "accountName": "abigale1989",
    "txId": "3966643439623631636430653230663064316539",
    "type": "USER_DEPOSIT_CYBEX",
    "status": "COMPLETED",   // Possible values: IN_PROGRESS/REJECTED/COMPLETED/ERROR
    "debugStatus": "DONE",          // This is for debug purpose. No need to show to end user.
    "address": null,                // It is external USDT address if it is USER_DEPOSIT_EXTERN or USER_WITHDRAWAL_EXTERN
    "assetName": "JADE.USDT",       // Asset name
    "assetId": "1.3.27",            // Asset id
    "amount": "1000",               // Amount
    "lastUpdateTime": "2019-06-28T02:07:36.088080Z"
  }
```

预估收益:

> = `(Current bxbt price - Order's boughtPx ) * Contract's conversionRate * Order's qtyContract - Order's commission`

建仓价格:

> `(current bxbt price - contract's strikeLevel) * Contract's conversionRate`

实际杠杆:
> `current bxbt price / (current bxbt price - contract's strikeLevel)`

Commission:
> `NumberOfContract * BTCPrice * ConversionRatio * CommisionRate`
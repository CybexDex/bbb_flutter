// To parse this JSON data, do
//
//     final postOrderRequestModel = postOrderRequestModelFromJson(jsonString);

import 'dart:convert';

class PostOrderRequestModel {
    String transactionType;
    String buyOrderTxId;
    Order buyOrder;
    Commission commission;
    String contractId;
    String underlyingSpotPx;
    Order sellOrder;
    String sellOrderTxId;
    String cutLossPx;
    String takeProfitPx;
    int expiration;

    PostOrderRequestModel({
        this.transactionType,
        this.buyOrderTxId,
        this.buyOrder,
        this.commission,
        this.contractId,
        this.underlyingSpotPx,
        this.sellOrder,
        this.sellOrderTxId,
        this.cutLossPx,
        this.takeProfitPx,
        this.expiration,
    });

    factory PostOrderRequestModel.fromRawJson(String str) => PostOrderRequestModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory PostOrderRequestModel.fromJson(Map<String, dynamic> json) => new PostOrderRequestModel(
        transactionType: json["transactionType"],
        buyOrderTxId: json["buyOrderTxId"],
        buyOrder: Order.fromJson(json["buyOrder"]),
        commission: Commission.fromJson(json["commission"]),
        contractId: json["contractId"],
        underlyingSpotPx: json["underlyingSpotPx"],
        sellOrder: Order.fromJson(json["sellOrder"]),
        sellOrderTxId: json["sellOrderTxId"],
        cutLossPx: json["cutLossPx"],
        takeProfitPx: json["takeProfitPx"],
        expiration: json["expiration"],
    );

    Map<String, dynamic> toJson() => {
        "transactionType": transactionType,
        "buyOrderTxId": buyOrderTxId,
        "buyOrder": buyOrder.toJson(),
        "commission": commission.toJson(),
        "contractId": contractId,
        "underlyingSpotPx": underlyingSpotPx,
        "sellOrder": sellOrder.toJson(),
        "sellOrderTxId": sellOrderTxId,
        "cutLossPx": cutLossPx,
        "takeProfitPx": takeProfitPx,
        "expiration": expiration,
    };
}

class Order {
    int refBlockNum;
    int refBlockPrefix;
    int txExpiration;
    AmountToSell fee;
    String seller;
    AmountToSell amountToSell;
    AmountToSell minToReceive;
    int expiration;
    int fillOrKill;
    String signature;

    Order({
        this.refBlockNum,
        this.refBlockPrefix,
        this.txExpiration,
        this.fee,
        this.seller,
        this.amountToSell,
        this.minToReceive,
        this.expiration,
        this.fillOrKill,
        this.signature,
    });

    factory Order.fromRawJson(String str) => Order.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Order.fromJson(Map<String, dynamic> json) => new Order(
        refBlockNum: json["refBlockNum"],
        refBlockPrefix: json["refBlockPrefix"],
        txExpiration: json["txExpiration"],
        fee: AmountToSell.fromJson(json["fee"]),
        seller: json["seller"],
        amountToSell: AmountToSell.fromJson(json["amountToSell"]),
        minToReceive: AmountToSell.fromJson(json["minToReceive"]),
        expiration: json["expiration"],
        fillOrKill: json["fill_or_kill"],
        signature: json["signature"],
    );

    Map<String, dynamic> toJson() => {
        "refBlockNum": refBlockNum,
        "refBlockPrefix": refBlockPrefix,
        "txExpiration": txExpiration,
        "fee": fee.toJson(),
        "seller": seller,
        "amountToSell": amountToSell.toJson(),
        "minToReceive": minToReceive.toJson(),
        "expiration": expiration,
        "fill_or_kill": fillOrKill,
        "signature": signature,
    };
}

class AmountToSell {
    String assetId;
    int amount;

    AmountToSell({
        this.assetId,
        this.amount,
    });

    factory AmountToSell.fromRawJson(String str) => AmountToSell.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory AmountToSell.fromJson(Map<String, dynamic> json) => new AmountToSell(
        assetId: json["assetId"],
        amount: json["amount"],
    );

    Map<String, dynamic> toJson() => {
        "assetId": assetId,
        "amount": amount,
    };
}

class Commission {
    int refBlockNum;
    int refBlockPrefix;
    int txExpiration;
    AmountToSell fee;
    String from;
    String to;
    AmountToSell amount;
    String signature;
    String txId;

    Commission({
        this.refBlockNum,
        this.refBlockPrefix,
        this.txExpiration,
        this.fee,
        this.from,
        this.to,
        this.amount,
        this.signature,
        this.txId,
    });

    factory Commission.fromRawJson(String str) => Commission.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Commission.fromJson(Map<String, dynamic> json) => new Commission(
        refBlockNum: json["refBlockNum"],
        refBlockPrefix: json["refBlockPrefix"],
        txExpiration: json["txExpiration"],
        fee: AmountToSell.fromJson(json["fee"]),
        from: json["from"],
        to: json["to"],
        amount: AmountToSell.fromJson(json["amount"]),
        signature: json["signature"],
        txId: json["txId"],
    );

    Map<String, dynamic> toJson() => {
        "refBlockNum": refBlockNum,
        "refBlockPrefix": refBlockPrefix,
        "txExpiration": txExpiration,
        "fee": fee.toJson(),
        "from": from,
        "to": to,
        "amount": amount.toJson(),
        "signature": signature,
        "txId": txId,
    };
}

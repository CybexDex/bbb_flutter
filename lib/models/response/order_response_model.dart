// To parse this JSON data, do
//
//     final orderResponseModel = orderResponseModelFromJson(jsonString);

import 'dart:convert';

class OrderResponseModel {
  String accountName;
  String status;
  String buyOrderTxId;
  String contractId;
  double latestContractPx;
  double pnl;
  double underlyingSpotPx;
  double cutLossPx;
  double takeProfitPx;
  double forceClosePx;
  DateTime expiration;
  double qtyContract;
  double commission;
  double accruedInterest;
  double boughtPx;
  double boughtContractPx;
  double boughtNotional;
  double soldPx;
  double soldContractPx;
  double soldNotional;
  String closeReason;
  String settleTime;
  DateTime createTime;
  DateTime lastUpdateTime;
  String details;

  OrderResponseModel({
    this.accountName,
    this.status,
    this.buyOrderTxId,
    this.contractId,
    this.latestContractPx,
    this.pnl,
    this.underlyingSpotPx,
    this.cutLossPx,
    this.takeProfitPx,
    this.forceClosePx,
    this.expiration,
    this.qtyContract,
    this.commission,
    this.accruedInterest,
    this.boughtPx,
    this.boughtContractPx,
    this.boughtNotional,
    this.soldPx,
    this.soldContractPx,
    this.soldNotional,
    this.closeReason,
    this.settleTime,
    this.createTime,
    this.lastUpdateTime,
    this.details,
  });

  factory OrderResponseModel.fromRawJson(String str) =>
      OrderResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) =>
      new OrderResponseModel(
        accountName: json["accountName"],
        status: json["status"],
        buyOrderTxId: json["buyOrderTxId"],
        contractId: json["contractId"],
        latestContractPx: json["latestContractPx"].toDouble(),
        pnl: json["pnl"].toDouble(),
        underlyingSpotPx: json["underlyingSpotPx"].toDouble(),
        cutLossPx: json["cutLossPx"].toDouble(),
        takeProfitPx: json["takeProfitPx"].toDouble(),
        forceClosePx: json["forceClosePx"].toDouble(),
        expiration: DateTime.parse(json["expiration"]),
        qtyContract: json["qtyContract"].toDouble(),
        commission: json["commission"].toDouble(),
        accruedInterest: json["accruedInterest"].toDouble(),
        boughtPx: json["boughtPx"].toDouble(),
        boughtContractPx: json["boughtContractPx"].toDouble(),
        boughtNotional: json["boughtNotional"].toDouble(),
        soldPx: json["soldPx"].toDouble(),
        soldContractPx: json["soldContractPx"].toDouble(),
        soldNotional: json["soldNotional"].toDouble(),
        closeReason: json["closeReason"],
        settleTime: json["settleTime"],
        createTime: DateTime.parse(json["createTime"]),
        lastUpdateTime: DateTime.parse(json["lastUpdateTime"]),
        details: json["details"],
      );

  Map<String, dynamic> toJson() => {
        "accountName": accountName,
        "status": status,
        "buyOrderTxId": buyOrderTxId,
        "contractId": contractId,
        "latestContractPx": latestContractPx,
        "pnl": pnl,
        "underlyingSpotPx": underlyingSpotPx,
        "cutLossPx": cutLossPx,
        "takeProfitPx": takeProfitPx,
        "forceClosePx": forceClosePx,
        "expiration": expiration.toIso8601String(),
        "qtyContract": qtyContract,
        "commission": commission,
        "accruedInterest": accruedInterest,
        "boughtPx": boughtPx,
        "boughtContractPx": boughtContractPx,
        "boughtNotional": boughtNotional,
        "soldPx": soldPx,
        "soldContractPx": soldContractPx,
        "soldNotional": soldNotional,
        "closeReason": closeReason,
        "settleTime": settleTime,
        "createTime": createTime.toIso8601String(),
        "lastUpdateTime": lastUpdateTime.toIso8601String(),
        "details": details,
      };
}

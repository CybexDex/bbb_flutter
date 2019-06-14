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
  String underlyingSpotPx;
  String cutLossPx;
  String takeProfitPx;
  DateTime expiration;
  String qtyContract;
  String commission;
  String boughtPx;
  String boughtContractPx;
  String boughtNotional;
  String soldPx;
  String soldContractPx;
  String soldNotional;
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
    this.expiration,
    this.qtyContract,
    this.commission,
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
        underlyingSpotPx: json["underlyingSpotPx"],
        cutLossPx: json["cutLossPx"],
        takeProfitPx: json["takeProfitPx"],
        expiration: DateTime.parse(json["expiration"]),
        qtyContract: json["qtyContract"],
        commission: json["commission"],
        boughtPx: json["boughtPx"],
        boughtContractPx: json["boughtContractPx"],
        boughtNotional: json["boughtNotional"],
        soldPx: json["soldPx"],
        soldContractPx: json["soldContractPx"],
        soldNotional: json["soldNotional"],
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
        "expiration": expiration.toIso8601String(),
        "qtyContract": qtyContract,
        "commission": commission,
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

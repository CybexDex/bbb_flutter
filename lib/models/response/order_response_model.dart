import 'dart:convert';

OrderResponseModel orderResponseModelFromJson(String str) =>
    OrderResponseModel.fromJson(json.decode(str));

String orderResponseModelToJson(OrderResponseModel data) =>
    json.encode(data.toJson());

class OrderResponseModel {
  String accountName;
  String status;
  String buyOrderTxId;
  String contractId;
  String underlyingSpotPx;
  String cutLossPx;
  String takeProfitPx;
  DateTime expiration;
  double qtyContract;
  double commission;
  double boughtPx;
  String boughtContractPx;
  String boughtNotional;
  String soldPx;
  String soldContractPx;
  String soldNotional;
  String closeReason;
  String settleTime;
  String createTime;
  String lastUpdateTime;

  OrderResponseModel({
    this.accountName,
    this.status,
    this.buyOrderTxId,
    this.contractId,
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
  });

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) =>
      new OrderResponseModel(
        accountName: json["accountName"],
        status: json["status"],
        buyOrderTxId: json["buyOrderTxId"],
        contractId: json["contractId"],
        underlyingSpotPx: json["underlyingSpotPx"],
        cutLossPx: json["cutLossPx"],
        takeProfitPx: json["takeProfitPx"],
        expiration: DateTime.parse(json["expiration"]),
        qtyContract: double.parse(json["qtyContract"]),
        commission: double.parse(json["commission"]),
        boughtPx: double.parse(json["boughtPx"]),
        boughtContractPx: json["boughtContractPx"],
        boughtNotional: json["boughtNotional"],
        soldPx: json["soldPx"],
        soldContractPx: json["soldContractPx"],
        soldNotional: json["soldNotional"],
        closeReason: json["closeReason"],
        settleTime: json["settleTime"],
        createTime: json["createTime"],
        lastUpdateTime: json["lastUpdateTime"],
      );

  Map<String, dynamic> toJson() => {
        "accountName": accountName,
        "status": status,
        "buyOrderTxId": buyOrderTxId,
        "contractId": contractId,
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
        "createTime": createTime,
        "lastUpdateTime": lastUpdateTime,
      };
}

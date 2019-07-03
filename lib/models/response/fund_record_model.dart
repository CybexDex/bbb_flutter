import 'dart:convert';

class FundRecordModel {
  String accountName;
  String txId;
  String type;
  String status;
  String debugStatus;
  String address;
  String assetName;
  String assetId;
  String amount;
  DateTime lastUpdateTime;

  FundRecordModel({
    this.accountName,
    this.txId,
    this.type,
    this.status,
    this.debugStatus,
    this.address,
    this.assetName,
    this.assetId,
    this.amount,
    this.lastUpdateTime,
  });

  factory FundRecordModel.fromRawJson(String str) =>
      FundRecordModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FundRecordModel.fromJson(Map<String, dynamic> json) =>
      new FundRecordModel(
        accountName: json["accountName"],
        txId: json["txId"],
        type: json["type"],
        status: json["status"],
        debugStatus: json["debugStatus"],
        address: json["address"],
        assetName: json["assetName"],
        assetId: json["assetId"],
        amount: json["amount"],
        lastUpdateTime: DateTime.parse(json["lastUpdateTime"]),
      );

  Map<String, dynamic> toJson() => {
        "accountName": accountName,
        "txId": txId,
        "type": type,
        "status": status,
        "debugStatus": debugStatus,
        "address": address,
        "assetName": assetName,
        "assetId": assetId,
        "amount": amount,
        "lastUpdateTime": lastUpdateTime.toIso8601String(),
      };
}

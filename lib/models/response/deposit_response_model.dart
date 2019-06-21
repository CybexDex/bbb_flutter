import 'dart:convert';

class DepositResponseModel {
  String address;
  String asset;
  String createAt;
  String cybName;

  DepositResponseModel({
    this.address,
    this.asset,
    this.createAt,
    this.cybName,
  });

  factory DepositResponseModel.fromRawJson(String str) =>
      DepositResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DepositResponseModel.fromJson(Map<String, dynamic> json) =>
      new DepositResponseModel(
        address: json["address"],
        asset: json["asset"],
        createAt: json["createAt"],
        cybName: json["cybName"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "asset": asset,
        "createAt": createAt,
        "cybName": cybName,
      };
}

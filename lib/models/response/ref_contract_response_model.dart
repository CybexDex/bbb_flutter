// To parse this JSON data, do
//
//     final refContractResponseModel = refContractResponseModelFromJson(jsonString);

import 'dart:convert';

class RefContractResponseModel {
  String chainId;
  String refBlockId;
  int refBlockNum;
  int refBlockPrefix;
  List<Contract> contract;

  RefContractResponseModel({
    this.chainId,
    this.refBlockId,
    this.refBlockNum,
    this.refBlockPrefix,
    this.contract,
  });

  factory RefContractResponseModel.fromRawJson(String str) =>
      RefContractResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RefContractResponseModel.fromJson(Map<String, dynamic> json) =>
      new RefContractResponseModel(
        chainId: json["chainId"],
        refBlockId: json["refBlockId"],
        refBlockNum: json["refBlockNum"],
        refBlockPrefix: json["refBlockPrefix"],
        contract: new List<Contract>.from(
            json["contract"].map((x) => Contract.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "chainId": chainId,
        "refBlockId": refBlockId,
        "refBlockNum": refBlockNum,
        "refBlockPrefix": refBlockPrefix,
        "contract": new List<dynamic>.from(contract.map((x) => x.toJson())),
      };
}

class Contract {
  String contractId;
  String assetName;
  String underlying;
  String conversionRate;
  String startGearing;
  String tradingStartTime;
  String tradingStopTime;
  String expiration;
  String availableInventory;
  String tickSize;
  String commissionRate;
  String quoteAsset;
  String status;
  String strikeLevel;
  String knockOutTime;
  String settlementUnderlyingPrice;
  String settlementPrice;
  String modificationTime;

  Contract({
    this.contractId,
    this.assetName,
    this.underlying,
    this.conversionRate,
    this.startGearing,
    this.tradingStartTime,
    this.tradingStopTime,
    this.expiration,
    this.availableInventory,
    this.tickSize,
    this.commissionRate,
    this.quoteAsset,
    this.status,
    this.strikeLevel,
    this.knockOutTime,
    this.settlementUnderlyingPrice,
    this.settlementPrice,
    this.modificationTime,
  });

  factory Contract.fromRawJson(String str) =>
      Contract.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Contract.fromJson(Map<String, dynamic> json) => new Contract(
        contractId: json["contractId"],
        assetName: json["assetName"],
        underlying: json["underlying"],
        conversionRate: json["conversionRate"],
        startGearing: json["startGearing"],
        tradingStartTime: json["tradingStartTime"],
        tradingStopTime: json["tradingStopTime"],
        expiration: json["expiration"],
        availableInventory: json["availableInventory"],
        tickSize: json["tickSize"],
        commissionRate: json["commissionRate"],
        quoteAsset: json["quoteAsset"],
        status: json["status"],
        strikeLevel: json["strikeLevel"],
        knockOutTime: json["knockOutTime"],
        settlementUnderlyingPrice: json["settlementUnderlyingPrice"],
        settlementPrice: json["settlementPrice"],
        modificationTime: json["modificationTime"],
      );

  Map<String, dynamic> toJson() => {
        "contractId": contractId,
        "assetName": assetName,
        "underlying": underlying,
        "conversionRate": conversionRate,
        "startGearing": startGearing,
        "tradingStartTime": tradingStartTime,
        "tradingStopTime": tradingStopTime,
        "expiration": expiration,
        "availableInventory": availableInventory,
        "tickSize": tickSize,
        "commissionRate": commissionRate,
        "quoteAsset": quoteAsset,
        "status": status,
        "strikeLevel": strikeLevel,
        "knockOutTime": knockOutTime,
        "settlementUnderlyingPrice": settlementUnderlyingPrice,
        "settlementPrice": settlementPrice,
        "modificationTime": modificationTime,
      };
}

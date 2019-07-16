// To parse this JSON data, do
//
//     final refContractResponseModel = refContractResponseModelFromJson(jsonString);

import 'dart:convert';

class RefContractResponseModel {
  String chainId;
  String refBlockId;
  int refBlockNum;
  int refBlockPrefix;
  Operator accountKeysEntityOperator;
  List<AvailableAsset> availableAssets;
  List<Contract> contract;

  RefContractResponseModel({
    this.chainId,
    this.refBlockId,
    this.refBlockNum,
    this.refBlockPrefix,
    this.accountKeysEntityOperator,
    this.availableAssets,
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
        accountKeysEntityOperator: Operator.fromJson(json["operator"]),
        availableAssets: new List<AvailableAsset>.from(
            json["availableAssets"].map((x) => AvailableAsset.fromJson(x))),
        contract: new List<Contract>.from(
            json["contract"].map((x) => Contract.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "chainId": chainId,
        "refBlockId": refBlockId,
        "refBlockNum": refBlockNum,
        "refBlockPrefix": refBlockPrefix,
        "operator": accountKeysEntityOperator.toJson(),
        "availableAssets":
            new List<dynamic>.from(availableAssets.map((x) => x.toJson())),
        "contract": new List<dynamic>.from(contract.map((x) => x.toJson())),
      };
}

class Operator {
  String accountName;
  String accountId;

  Operator({
    this.accountName,
    this.accountId,
  });

  factory Operator.fromRawJson(String str) =>
      Operator.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Operator.fromJson(Map<String, dynamic> json) => new Operator(
        accountName: json["accountName"],
        accountId: json["accountId"],
      );

  Map<String, dynamic> toJson() => {
        "accountName": accountName,
        "accountId": accountId,
      };
}

class AvailableAsset {
  String assetName;
  String assetId;
  int precision;

  AvailableAsset({
    this.assetName,
    this.assetId,
    this.precision,
  });

  factory AvailableAsset.fromRawJson(String str) =>
      AvailableAsset.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AvailableAsset.fromJson(Map<String, dynamic> json) =>
      new AvailableAsset(
        assetName: json["assetName"],
        assetId: json["assetId"],
        precision: json["precision"],
      );

  Map<String, dynamic> toJson() => {
        "assetName": assetName,
        "assetId": assetId,
        "precision": precision,
      };
}

class Contract {
  String contractId;
  String assetName;
  String underlying;
  double conversionRate;
  double availableInventory;
  double tickSize;
  double commissionRate;
  String quoteAsset;
  String status;
  double strikeLevel;
  double dailyInterest;
  double maxGearing;
  double maxOrderQty;
  String modificationTime;

  Contract({
    this.contractId,
    this.assetName,
    this.underlying,
    this.conversionRate,
    this.availableInventory,
    this.tickSize,
    this.commissionRate,
    this.quoteAsset,
    this.status,
    this.strikeLevel,
    this.dailyInterest,
    this.maxGearing,
    this.maxOrderQty,
    this.modificationTime,
  });

  factory Contract.fromRawJson(String str) =>
      Contract.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Contract.fromJson(Map<String, dynamic> json) => new Contract(
        contractId: json["contractId"],
        assetName: json["assetName"],
        underlying: json["underlying"],
        conversionRate: json["conversionRate"].toDouble(),
        availableInventory: json["availableInventory"].toDouble(),
        tickSize: json["tickSize"].toDouble(),
        commissionRate: json["commissionRate"].toDouble(),
        quoteAsset: json["quoteAsset"],
        status: json["status"],
        strikeLevel: json["strikeLevel"].toDouble(),
        dailyInterest: json["dailyInterest"].toDouble(),
        maxGearing: json["maxGearing"].toDouble(),
        maxOrderQty: json["maxOrderQty"].toDouble(),
        modificationTime: json["modificationTime"],
      );

  Map<String, dynamic> toJson() => {
        "contractId": contractId,
        "assetName": assetName,
        "underlying": underlying,
        "conversionRate": conversionRate,
        "availableInventory": availableInventory,
        "tickSize": tickSize,
        "commissionRate": commissionRate,
        "quoteAsset": quoteAsset,
        "status": status,
        "strikeLevel": strikeLevel,
        "dailyInterest": dailyInterest,
        "maxGearing": maxGearing,
        "maxOrderQty": maxOrderQty,
        "modificationTime": modificationTime,
      };

  @override
  bool operator ==(o) => o is Contract && o.contractId == contractId;

  @override
  int get hashCode => contractId.hashCode;
}

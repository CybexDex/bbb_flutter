// To parse this JSON data, do
//
//     final refContractResponseModel = refContractResponseModelFromJson(jsonString);

import 'dart:convert';

class RefContractResponseModel {
    String chainId;
    String refBlockId;
    int refBlockNum;
    int refBlockPrefix;
    Operator refContractResponseModelOperator;
    List<AvailableAsset> availableAssets;
    List<Contract> contract;

    RefContractResponseModel({
        this.chainId,
        this.refBlockId,
        this.refBlockNum,
        this.refBlockPrefix,
        this.refContractResponseModelOperator,
        this.availableAssets,
        this.contract,
    });

    factory RefContractResponseModel.fromRawJson(String str) => RefContractResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory RefContractResponseModel.fromJson(Map<String, dynamic> json) => new RefContractResponseModel(
        chainId: json["chainId"],
        refBlockId: json["refBlockId"],
        refBlockNum: json["refBlockNum"],
        refBlockPrefix: json["refBlockPrefix"],
        refContractResponseModelOperator: Operator.fromJson(json["operator"]),
        availableAssets: new List<AvailableAsset>.from(json["availableAssets"].map((x) => AvailableAsset.fromJson(x))),
        contract: new List<Contract>.from(json["contract"].map((x) => Contract.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "chainId": chainId,
        "refBlockId": refBlockId,
        "refBlockNum": refBlockNum,
        "refBlockPrefix": refBlockPrefix,
        "operator": refContractResponseModelOperator.toJson(),
        "availableAssets": new List<dynamic>.from(availableAssets.map((x) => x.toJson())),
        "contract": new List<dynamic>.from(contract.map((x) => x.toJson())),
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

    factory AvailableAsset.fromRawJson(String str) => AvailableAsset.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory AvailableAsset.fromJson(Map<String, dynamic> json) => new AvailableAsset(
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

    factory Contract.fromRawJson(String str) => Contract.fromJson(json.decode(str));

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

class Operator {
    String accountName;
    String accountId;

    Operator({
        this.accountName,
        this.accountId,
    });

    factory Operator.fromRawJson(String str) => Operator.fromJson(json.decode(str));

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

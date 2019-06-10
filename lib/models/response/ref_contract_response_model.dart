class RefContractResponseModel {
  String chainId;
  List<RefContractResponseContract> contract;
  String refBlockId;

  RefContractResponseModel({this.chainId, this.contract, this.refBlockId});

  RefContractResponseModel.fromJson(Map<String, dynamic> json) {
    chainId = json['chainId'];
    if (json['contract'] != null) {
      contract = new List<RefContractResponseContract>();
      (json['contract'] as List).forEach((v) {
        contract.add(new RefContractResponseContract.fromJson(v));
      });
    }
    refBlockId = json['refBlockId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chainId'] = this.chainId;
    if (this.contract != null) {
      data['contract'] = this.contract.map((v) => v.toJson()).toList();
    }
    data['refBlockId'] = this.refBlockId;
    return data;
  }
}

//class RefContractResponseAvailableasset {
//  String assetId;
//  int precision;
//  String assetName;
//
//  RefContractResponseAvailableasset(
//      {this.assetId, this.precision, this.assetName});
//
//  RefContractResponseAvailableasset.fromJson(Map<String, dynamic> json) {
//    assetId = json['assetId'];
//    precision = json['precision'];
//    assetName = json['assetName'];
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['assetId'] = this.assetId;
//    data['precision'] = this.precision;
//    data['assetName'] = this.assetName;
//    return data;
//  }
//}

class RefContractResponseContract {
  String contractId;
  String assetName;
  String underlying;
  double conversionRate;
  String startGearing;
  String tradingStartTime;
  String tradingStopTime;
  String expiration;
  String availableInventory;
  String tickSize;
  String commissionRate;
  String quoteAsset;
  String status;
  double strikeLevel;
  String knockOutTime;
  String settlementUnderlyingPrice;
  String settlementPrice;
  String modificationTime;

  RefContractResponseContract({
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

  factory RefContractResponseContract.fromJson(Map<String, dynamic> json) =>
      new RefContractResponseContract(
        contractId: json["contractId"],
        assetName: json["assetName"],
        underlying: json["underlying"],
        conversionRate: double.parse(json["conversionRate"]),
        startGearing: json["startGearing"],
        tradingStartTime: json["tradingStartTime"],
        tradingStopTime: json["tradingStopTime"],
        expiration: json["expiration"],
        availableInventory: json["availableInventory"],
        tickSize: json["tickSize"],
        commissionRate: json["commissionRate"],
        quoteAsset: json["quoteAsset"],
        status: json["status"],
        strikeLevel: double.parse(json["strikeLevel"]),
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

import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class ContractResponse {
  List<Contract> contract;

  ContractResponse({
    this.contract,
  });

  factory ContractResponse.fromJson(jsonRes) {
    if (jsonRes == null) return null;

    List<Contract> contract = jsonRes['contract'] is List ? [] : null;
    if (contract != null) {
      for (var item in jsonRes['contract']) {
        if (item != null) {
          contract.add(Contract.fromJson(item));
        }
      }
    }
    return ContractResponse(
      contract: contract,
    );
  }

  Map<String, dynamic> toJson() => {
        'contract': contract,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class Contract {
  String contractId;
  double conversionRate;
  int availableInventory;
  double tickSize;
  double commissionRate;
  String status;
  double strikeLevel;
  double dailyInterest;
  double maxGearing;
  double maxOrderQty;

  Contract({
    this.contractId,
    this.conversionRate,
    this.availableInventory,
    this.tickSize,
    this.commissionRate,
    this.status,
    this.strikeLevel,
    this.dailyInterest,
    this.maxGearing,
    this.maxOrderQty,
  });

  factory Contract.fromJson(jsonRes) => jsonRes == null
      ? null
      : Contract(
          contractId: convertValueByType(jsonRes['contractId'], String,
              stack: "Contract-contractId"),
          conversionRate: convertValueByType(jsonRes['conversionRate'], double,
              stack: "Contract-conversionRate"),
          availableInventory: convertValueByType(
              jsonRes['availableInventory'], int,
              stack: "Contract-availableInventory"),
          tickSize: convertValueByType(jsonRes['tickSize'], double,
              stack: "Contract-tickSize"),
          commissionRate: convertValueByType(jsonRes['commissionRate'], double,
              stack: "Contract-commissionRate"),
          status: convertValueByType(jsonRes['status'], String,
              stack: "Contract-status"),
          strikeLevel: convertValueByType(jsonRes['strikeLevel'], double,
              stack: "Contract-strikeLevel"),
          dailyInterest: convertValueByType(jsonRes['dailyInterest'], double,
              stack: "Contract-dailyInterest"),
          maxGearing: convertValueByType(jsonRes['maxGearing'], double,
              stack: "Contract-maxGearing"),
          maxOrderQty: convertValueByType(jsonRes['maxOrderQty'], double,
              stack: "Contract-maxOrderQty"),
        );

  Map<String, dynamic> toJson() => {
        'contractId': contractId,
        'conversionRate': conversionRate,
        'availableInventory': availableInventory,
        'tickSize': tickSize,
        'commissionRate': commissionRate,
        'status': status,
        'strikeLevel': strikeLevel,
        'dailyInterest': dailyInterest,
        'maxGearing': maxGearing,
        'maxOrderQty': maxOrderQty,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

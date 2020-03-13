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
  double tickSize;
  double commissionRate;
  double strikeLevel;

  Contract({
    this.contractId,
    this.conversionRate,
    this.tickSize,
    this.commissionRate,
    this.strikeLevel,
  });

  factory Contract.fromJson(jsonRes) => jsonRes == null
      ? null
      : Contract(
          contractId: convertValueByType(jsonRes['contractId'], String,
              stack: "Contract-contractId"),
          conversionRate: convertValueByType(jsonRes['conversionRate'], double,
              stack: "Contract-conversionRate"),
          tickSize: convertValueByType(jsonRes['tickSize'], double,
              stack: "Contract-tickSize"),
          commissionRate: convertValueByType(jsonRes['commissionRate'], double,
              stack: "Contract-commissionRate"),
          strikeLevel: convertValueByType(jsonRes['strikeLevel'], double,
              stack: "Contract-strikeLevel"),
        );

  Map<String, dynamic> toJson() => {
        'contractId': contractId,
        'conversionRate': conversionRate,
        'tickSize': tickSize,
        'commissionRate': commissionRate,
        'strikeLevel': strikeLevel,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

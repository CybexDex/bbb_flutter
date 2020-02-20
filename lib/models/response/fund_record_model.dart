import 'dart:convert';

import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class FundRecordModel {
  String accountName;
  String action;
  String direction;
  String subtype;
  double amount;
  String time;
  String custom;

  FundRecordModel({
    this.accountName,
    this.action,
    this.direction,
    this.subtype,
    this.amount,
    this.time,
    this.custom,
  });

  factory FundRecordModel.fromJson(jsonRes) => jsonRes == null
      ? null
      : FundRecordModel(
          accountName: convertValueByType(jsonRes['accountName'], String,
              stack: "Root-accountName"),
          action: convertValueByType(jsonRes['action'], String,
              stack: "Root-action"),
          direction: convertValueByType(jsonRes['direction'], String,
              stack: "Root-direction"),
          subtype: convertValueByType(jsonRes['subtype'], String,
              stack: "Root-subtype"),
          amount: convertValueByType(jsonRes['amount'], double,
              stack: "Root-amount"),
          time: convertValueByType(jsonRes['time'], String, stack: "Root-time"),
          custom: convertValueByType(jsonRes['custom'], String,
              stack: "Root-custom"),
        );

  Map<String, dynamic> toJson() => {
        'accountName': accountName,
        'action': action,
        'direction': direction,
        'subtype': subtype,
        'amount': amount,
        'time': time,
        'custom': custom,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

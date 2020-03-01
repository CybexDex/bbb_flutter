import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class OpenLimitOrderRequestModel {
  Data data;
  String signature;

  OpenLimitOrderRequestModel({
    this.data,
    this.signature,
  });

  factory OpenLimitOrderRequestModel.fromJson(jsonRes) => jsonRes == null
      ? null
      : OpenLimitOrderRequestModel(
          data: Data.fromJson(jsonRes['data']),
          signature: convertValueByType(jsonRes['signature'], String,
              stack: "Root-signature"),
        );

  Map<String, dynamic> toJson() => {
        'data': data,
        'signature': signature,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class Data {
  String action;
  String user;
  String contract;
  String takeProfitPrice;
  String cutlossPrice;
  int quantity;
  String paid;
  String lowestTriggerPrice;
  String highestTriggerPrice;
  String deadline;
  int timeout;

  Data({
    this.action,
    this.user,
    this.contract,
    this.takeProfitPrice,
    this.cutlossPrice,
    this.quantity,
    this.paid,
    this.lowestTriggerPrice,
    this.highestTriggerPrice,
    this.deadline,
    this.timeout,
  });

  factory Data.fromJson(jsonRes) => jsonRes == null
      ? null
      : Data(
          action: convertValueByType(jsonRes['action'], String,
              stack: "Data-action"),
          user: convertValueByType(jsonRes['user'], String, stack: "Data-user"),
          contract: convertValueByType(jsonRes['contract'], String,
              stack: "Data-contract"),
          takeProfitPrice: convertValueByType(
              jsonRes['take_profit_price'], String,
              stack: "Data-take_profit_price"),
          cutlossPrice: convertValueByType(jsonRes['cutloss_price'], String,
              stack: "Data-cutloss_price"),
          quantity: convertValueByType(jsonRes['quantity'], int,
              stack: "Data-quantity"),
          paid: convertValueByType(jsonRes['paid'], String, stack: "Data-paid"),
          lowestTriggerPrice: convertValueByType(
              jsonRes['lowest_trigger_price'], String,
              stack: "Data-lowest_trigger_price"),
          highestTriggerPrice: convertValueByType(
              jsonRes['highest_trigger_price'], String,
              stack: "Data-highest_trigger_price"),
          deadline: convertValueByType(jsonRes['deadline'], String,
              stack: "Data-deadline"),
          timeout: convertValueByType(jsonRes['timeout'], int,
              stack: "Data-timeout"),
        );

  Map<String, dynamic> toJson() => {
        'action': action,
        'user': user,
        'contract': contract,
        'take_profit_price': takeProfitPrice,
        'cutloss_price': cutlossPrice,
        'quantity': quantity,
        'paid': paid,
        'lowest_trigger_price': lowestTriggerPrice,
        'highest_trigger_price': highestTriggerPrice,
        'deadline': deadline,
        'timeout': timeout,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

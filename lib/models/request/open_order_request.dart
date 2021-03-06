import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class OpenOrderRequest {
  Data data;
  String signature;

  OpenOrderRequest({
    this.data,
    this.signature,
  });

  factory OpenOrderRequest.fromJson(jsonRes) => jsonRes == null
      ? null
      : OpenOrderRequest(
          data: Data.fromJson(jsonRes['data']),
          signature: convertValueByType(jsonRes['signature'], String,
              stack: "Root-signature"),
        );

  Map<String, dynamic> toJson() => {
        'data': data.toJson(),
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
  int timeout;

  Data({
    this.action,
    this.user,
    this.contract,
    this.takeProfitPrice,
    this.cutlossPrice,
    this.quantity,
    this.paid,
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
        'timeout': timeout,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

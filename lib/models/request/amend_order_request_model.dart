import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class AmendOrderRequestModel {
  Data data;
  String signature;

  AmendOrderRequestModel({
    this.data,
    this.signature,
  });

  factory AmendOrderRequestModel.fromJson(jsonRes) => jsonRes == null
      ? null
      : AmendOrderRequestModel(
          data: Data.fromJson(jsonRes['data']),
          signature: convertValueByType(jsonRes['signature'], String,
              stack: "Root-signature"),
        );

  Map<String, dynamic> toJson() => {
        'data': data,
        'signature': signature,
      };

  Map<String, dynamic> toCloseJson() => {
        'data': data.toCloseJson(),
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
  int orderId;
  String takeProfitPrice;
  String cutlossPrice;
  int timeout;

  Data({
    this.action,
    this.user,
    this.orderId,
    this.takeProfitPrice,
    this.cutlossPrice,
    this.timeout,
  });

  factory Data.fromJson(jsonRes) => jsonRes == null
      ? null
      : Data(
          action: convertValueByType(jsonRes['action'], String,
              stack: "Data-action"),
          user: convertValueByType(jsonRes['user'], String, stack: "Data-user"),
          orderId: convertValueByType(jsonRes['order_id'], int,
              stack: "Data-order_id"),
          takeProfitPrice: convertValueByType(
              jsonRes['take_profit_price'], String,
              stack: "Data-take_profit_price"),
          cutlossPrice: convertValueByType(jsonRes['cutloss_price'], String,
              stack: "Data-cutloss_price"),
          timeout: convertValueByType(jsonRes['timeout'], int,
              stack: "Data-timeout"),
        );

  Map<String, dynamic> toJson() => {
        'action': action,
        'user': user,
        'order_id': orderId,
        'take_profit_price': takeProfitPrice,
        'cutloss_price': cutlossPrice,
        'timeout': timeout,
      };

  Map<String, dynamic> toCloseJson() => {
        'action': action,
        'user': user,
        'order_id': orderId,
        'timeout': timeout,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

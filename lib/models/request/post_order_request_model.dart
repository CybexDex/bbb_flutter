// To parse this JSON data, do
//
//     final postOrderRequestModel = postOrderRequestModelFromJson(jsonString);

import 'dart:convert';

import 'package:cybex_flutter_plugin/commision.dart';
import 'package:cybex_flutter_plugin/order.dart';

class PostOrderRequestModel {
  String transactionType;
  String buyOrderTxId;
  Order buyOrder;
  Commission commission;
  String contractId;
  String underlyingSpotPx;
  Order sellOrder;
  String sellOrderTxId;
  String cutLossPx;
  String takeProfitPx;
  int expiration;
  
  PostOrderRequestModel({
    this.transactionType = "NxOrder",
    this.buyOrderTxId,
    this.buyOrder,
    this.commission,
    this.contractId,
    this.underlyingSpotPx,
    this.sellOrder,
    this.sellOrderTxId,
    this.cutLossPx = "0",
    this.takeProfitPx = "0",
    this.expiration = 0,
  });

  factory PostOrderRequestModel.fromRawJson(String str) =>
      PostOrderRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostOrderRequestModel.fromJson(Map<String, dynamic> json) =>
      new PostOrderRequestModel(
        transactionType: json["transactionType"],
        buyOrderTxId: json["buyOrderTxId"],
        buyOrder: Order.fromJson(json["buyOrder"]),
        commission: Commission.fromJson(json["commission"]),
        contractId: json["contractId"],
        underlyingSpotPx: json["underlyingSpotPx"],
        sellOrder: Order.fromJson(json["sellOrder"]),
        sellOrderTxId: json["sellOrderTxId"],
        cutLossPx: json["cutLossPx"],
        takeProfitPx: json["takeProfitPx"],
        expiration: json["expiration"],
      );

  Map<String, dynamic> toJson() => {
        "transactionType": transactionType,
        "buyOrderTxId": buyOrderTxId,
        "buyOrder": buyOrder.toJson(),
        "commission": commission.toJson(),
        "contractId": contractId,
        "underlyingSpotPx": underlyingSpotPx,
        "sellOrder": sellOrder.toJson(),
        "sellOrderTxId": sellOrderTxId,
        "cutLossPx": cutLossPx,
        "takeProfitPx": takeProfitPx,
        "expiration": expiration,
      };
}

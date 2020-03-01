import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class LimitOrderResponse {
  String accountName;
  String status;
  int orderId;
  String contractId;
  double cutLossPx;
  double takeProfitPx;
  String expiration;
  double qtyContract;
  double commission;
  double paidAmount;
  double strikePx;
  double lowestTriggerPx;
  double highestTriggerPx;
  double boughtContractPx;
  double boughtNotional;
  String failReason;
  String createTime;
  String details;

  LimitOrderResponse({
    this.accountName,
    this.status,
    this.orderId,
    this.contractId,
    this.cutLossPx,
    this.takeProfitPx,
    this.paidAmount,
    this.expiration,
    this.qtyContract,
    this.commission,
    this.strikePx,
    this.lowestTriggerPx,
    this.highestTriggerPx,
    this.boughtContractPx,
    this.boughtNotional,
    this.failReason,
    this.createTime,
    this.details,
  });

  factory LimitOrderResponse.fromJson(jsonRes) => jsonRes == null
      ? null
      : LimitOrderResponse(
          accountName: convertValueByType(jsonRes['accountName'], String,
              stack: "Root-accountName"),
          status: convertValueByType(jsonRes['status'], String,
              stack: "Root-status"),
          orderId: convertValueByType(jsonRes['orderId'], int,
              stack: "Root-orderId"),
          contractId: convertValueByType(jsonRes['contractId'], String,
              stack: "Root-contractId"),
          cutLossPx: convertValueByType(jsonRes['cutLossPx'], double,
              stack: "Root-cutLossPx"),
          takeProfitPx: convertValueByType(jsonRes['takeProfitPx'], double,
              stack: "Root-takeProfitPx"),
          expiration: convertValueByType(jsonRes['expiration'], String,
              stack: "Root-expiration"),
          qtyContract: convertValueByType(jsonRes['qtyContract'], double,
              stack: "Root-qtyContract"),
          commission: convertValueByType(jsonRes['commission'], double,
              stack: "Root-commission"),
          paidAmount: convertValueByType(jsonRes['paidAmount'], double,
              stack: "Root-commission"),
          strikePx: convertValueByType(jsonRes['strikePx'], double,
              stack: "Root-strikePx"),
          lowestTriggerPx: convertValueByType(
              jsonRes['lowestTriggerPx'], double,
              stack: "Root-lowestTriggerPx"),
          highestTriggerPx: convertValueByType(
              jsonRes['highestTriggerPx'], double,
              stack: "Root-highestTriggerPx"),
          boughtContractPx: convertValueByType(
              jsonRes['boughtContractPx'], double,
              stack: "Root-boughtContractPx"),
          boughtNotional: convertValueByType(jsonRes['boughtNotional'], double,
              stack: "Root-boughtNotional"),
          failReason: convertValueByType(jsonRes['failReason'], String,
              stack: "Root-cancelReason"),
          createTime: convertValueByType(jsonRes['createTime'], String,
              stack: "Root-createTime"),
          details: convertValueByType(jsonRes['details'], String,
              stack: "Root-details"),
        );

  Map<String, dynamic> toJson() => {
        'accountName': accountName,
        'status': status,
        'orderId': orderId,
        'contractId': contractId,
        'cutLossPx': cutLossPx,
        'takeProfitPx': takeProfitPx,
        'expiration': expiration,
        'qtyContract': qtyContract,
        'commission': commission,
        'paidAmount': paidAmount,
        'strikePx': strikePx,
        'lowestTriggerPx': lowestTriggerPx,
        'highestTriggerPx': highestTriggerPx,
        'boughtContractPx': boughtContractPx,
        'boughtNotional': boughtNotional,
        'failReason': failReason,
        'createTime': createTime,
        'details': details,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

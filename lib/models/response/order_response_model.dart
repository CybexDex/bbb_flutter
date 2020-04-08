import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class OrderResponseModel {
  String accountName;
  String status;
  String action;
  int buyOrderTxId;
  String contractId;
  double latestContractPx;
  double pnl;
  double underlyingSpotPx;
  double cutLossPx;
  double takeProfitPx;
  double forceClosePx;
  String expiration;
  double qtyContract;
  double commission;
  double accruedInterest;
  double strikePx;
  double boughtPx;
  double boughtContractPx;
  double boughtNotional;
  double soldPx;
  double soldContractPx;
  double soldNotional;
  String closeReason;
  String settleTime;
  String createTime;
  String lastUpdateTime;
  String details;

  OrderResponseModel({
    this.accountName,
    this.status,
    this.action,
    this.buyOrderTxId,
    this.contractId,
    this.latestContractPx,
    this.pnl,
    this.underlyingSpotPx,
    this.cutLossPx,
    this.takeProfitPx,
    this.forceClosePx,
    this.expiration,
    this.qtyContract,
    this.commission,
    this.accruedInterest,
    this.strikePx,
    this.boughtPx,
    this.boughtContractPx,
    this.boughtNotional,
    this.soldPx,
    this.soldContractPx,
    this.soldNotional,
    this.closeReason,
    this.settleTime,
    this.createTime,
    this.lastUpdateTime,
    this.details,
  });

  factory OrderResponseModel.fromJson(jsonRes) => jsonRes == null
      ? null
      : OrderResponseModel(
          accountName:
              convertValueByType(jsonRes['accountName'], String, stack: "Root-accountName"),
          status: convertValueByType(jsonRes['status'], String, stack: "Root-status"),
          action: convertValueByType(jsonRes['action'], String, stack: "Root-action"),
          buyOrderTxId:
              convertValueByType(jsonRes['buyOrderTxId'], int, stack: "Root-buyOrderTxId"),
          contractId: convertValueByType(jsonRes['contractId'], String, stack: "Root-contractId"),
          latestContractPx: convertValueByType(jsonRes['latestContractPx'], double,
              stack: "Root-latestContractPx"),
          pnl: convertValueByType(jsonRes['pnl'], double, stack: "Root-pnl"),
          underlyingSpotPx: convertValueByType(jsonRes['underlyingSpotPx'], double,
              stack: "Root-underlyingSpotPx"),
          cutLossPx: convertValueByType(jsonRes['cutLossPx'], double, stack: "Root-cutLossPx"),
          takeProfitPx:
              convertValueByType(jsonRes['takeProfitPx'], double, stack: "Root-takeProfitPx"),
          forceClosePx:
              convertValueByType(jsonRes['forceClosePx'], double, stack: "Root-forceClosePx"),
          expiration: convertValueByType(jsonRes['expiration'], String, stack: "Root-expiration"),
          qtyContract:
              convertValueByType(jsonRes['qtyContract'], double, stack: "Root-qtyContract"),
          commission: convertValueByType(jsonRes['commission'], double, stack: "Root-commission"),
          accruedInterest:
              convertValueByType(jsonRes['accruedInterest'], double, stack: "Root-accruedInterest"),
          strikePx: convertValueByType(jsonRes['strikePx'], double, stack: "Root-boughtPx"),
          boughtPx: convertValueByType(jsonRes['boughtPx'], double, stack: "Root-boughtPx"),
          boughtContractPx: convertValueByType(jsonRes['boughtContractPx'], double,
              stack: "Root-boughtContractPx"),
          boughtNotional:
              convertValueByType(jsonRes['boughtNotional'], double, stack: "Root-boughtNotional"),
          soldPx: convertValueByType(jsonRes['soldPx'], double, stack: "Root-soldPx"),
          soldContractPx:
              convertValueByType(jsonRes['soldContractPx'], double, stack: "Root-soldContractPx"),
          soldNotional:
              convertValueByType(jsonRes['soldNotional'], double, stack: "Root-soldNotional"),
          closeReason:
              convertValueByType(jsonRes['closeReason'], String, stack: "Root-closeReason"),
          settleTime: convertValueByType(jsonRes['settleTime'], String, stack: "Root-settleTime"),
          createTime: convertValueByType(jsonRes['createTime'], String, stack: "Root-createTime"),
          lastUpdateTime:
              convertValueByType(jsonRes['lastUpdateTime'], String, stack: "Root-lastUpdateTime"),
          details: convertValueByType(jsonRes['details'], String, stack: "Root-details"),
        );

  Map<String, dynamic> toJson() => {
        'accountName': accountName,
        'status': status,
        'action': action,
        'buyOrderTxId': buyOrderTxId,
        'contractId': contractId,
        'latestContractPx': latestContractPx,
        'pnl': pnl,
        'underlyingSpotPx': underlyingSpotPx,
        'cutLossPx': cutLossPx,
        'takeProfitPx': takeProfitPx,
        'forceClosePx': forceClosePx,
        'expiration': expiration,
        'qtyContract': qtyContract,
        'commission': commission,
        'accruedInterest': accruedInterest,
        'strikePx': strikePx,
        'boughtPx': boughtPx,
        'boughtContractPx': boughtContractPx,
        'boughtNotional': boughtNotional,
        'soldPx': soldPx,
        'soldContractPx': soldContractPx,
        'soldNotional': soldNotional,
        'closeReason': closeReason,
        'settleTime': settleTime,
        'createTime': createTime,
        'lastUpdateTime': lastUpdateTime,
        'details': details,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

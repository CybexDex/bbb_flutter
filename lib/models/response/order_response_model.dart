import 'dart:convert' show json;
import 'package:bbb_flutter/helper/utils.dart';

class OrderResponseModel {
  String accountName;
  String status;
  String buyOrderTxId;
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
          accountName: convertValueByType(jsonRes['accountName'], String,
              stack: "Test-accountName"),
          status: convertValueByType(jsonRes['status'], String,
              stack: "Test-status"),
          buyOrderTxId: convertValueByType(jsonRes['buyOrderTxId'], String,
              stack: "Test-buyOrderTxId"),
          contractId: convertValueByType(jsonRes['contractId'], String,
              stack: "Test-contractId"),
          latestContractPx: convertValueByType(
              jsonRes['latestContractPx'], double,
              stack: "Test-latestContractPx"),
          pnl: convertValueByType(jsonRes['pnl'], double, stack: "Test-pnl"),
          underlyingSpotPx: convertValueByType(
              jsonRes['underlyingSpotPx'], double,
              stack: "Test-underlyingSpotPx"),
          cutLossPx: convertValueByType(jsonRes['cutLossPx'], double,
              stack: "Test-cutLossPx"),
          takeProfitPx: convertValueByType(jsonRes['takeProfitPx'], double,
              stack: "Test-takeProfitPx"),
          forceClosePx: convertValueByType(jsonRes['forceClosePx'], double,
              stack: "Test-forceClosePx"),
          expiration: convertValueByType(jsonRes['expiration'], String,
              stack: "Test-expiration"),
          qtyContract: convertValueByType(jsonRes['qtyContract'], double,
              stack: "Test-qtyContract"),
          commission: convertValueByType(jsonRes['commission'], double,
              stack: "Test-commission"),
          accruedInterest: convertValueByType(
              jsonRes['accruedInterest'], double,
              stack: "Test-accruedInterest"),
          boughtPx: convertValueByType(jsonRes['boughtPx'], double,
              stack: "Test-boughtPx"),
          boughtContractPx: convertValueByType(
              jsonRes['boughtContractPx'], double,
              stack: "Test-boughtContractPx"),
          boughtNotional: convertValueByType(jsonRes['boughtNotional'], double,
              stack: "Test-boughtNotional"),
          soldPx: convertValueByType(jsonRes['soldPx'], double,
              stack: "Test-soldPx"),
          soldContractPx: convertValueByType(jsonRes['soldContractPx'], double,
              stack: "Test-soldContractPx"),
          soldNotional: convertValueByType(jsonRes['soldNotional'], double,
              stack: "Test-soldNotional"),
          closeReason: convertValueByType(jsonRes['closeReason'], String,
              stack: "Test-closeReason"),
          settleTime: convertValueByType(jsonRes['settleTime'], String,
              stack: "Test-settleTime"),
          createTime: convertValueByType(jsonRes['createTime'], String,
              stack: "Test-createTime"),
          lastUpdateTime: convertValueByType(jsonRes['lastUpdateTime'], String,
              stack: "Test-lastUpdateTime"),
          details: convertValueByType(jsonRes['details'], String,
              stack: "Test-details"),
        );

  Map<String, dynamic> toJson() => {
        'accountName': accountName,
        'status': status,
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

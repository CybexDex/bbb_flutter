import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
import 'package:flutter/foundation.dart';

enum BuildMode { release, debug, profile }

enum UnlockType { none, cloud, key }

enum LockTimeType { lower, middle, high }

const Map<LockTimeType, int> UnlockTimes = {
  LockTimeType.lower: 300,
  LockTimeType.middle: 1200,
  LockTimeType.high: 3600,
};

enum LoginType { none, cloud, key }

enum OrderStatus { open, closed, rejected }
const Map<OrderStatus, String> orderStatusMap = {
  OrderStatus.open: "OPEN",
  OrderStatus.closed: "CLOSED",
  OrderStatus.rejected: "REJECTED",
};

enum FundType {
  userDepositExtern,
  userWithdrawExtern,
  adminAdjust,
  userDepositCybex,
  userWithdrawCybex
}
const Map<FundType, String> fundTypeMap = {
  FundType.userDepositExtern:
      "USER_DEPOSIT_EXTERN", //user deposits USDT from outside

  FundType.userWithdrawExtern:
      "USER_WITHDRAWAL_EXTERN", //user withdraws USDT to outside

  FundType.adminAdjust: "ADMIN_ADJUST", // admin fixes balance issue

  FundType.userDepositCybex:
      "USER_DEPOSIT_CYBEX", // user deposits USDT from its cybex wallet

  FundType.userWithdrawCybex:
      "USER_WITHDRAWAL_CYBEX", //user withdraws USDT to its cybex wallet
};

enum FundStatus { inProgress, rejected, completed, error }
const Map<FundStatus, String> fundStatusMap = {
  FundStatus.inProgress: "IN_PROGRESS",
  FundStatus.rejected: "REJECTED",
  FundStatus.completed: "COMPLETED",
  FundStatus.error: "ERROR",
};

/**
 * Route Types
 */
class RouteParamsOfTrade {
  final Contract contract;
  final bool isUp;
  final String title;

  RouteParamsOfTrade(
      {@required this.contract, @required this.isUp, @required this.title});
}

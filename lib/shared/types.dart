import 'package:bbb_flutter/models/response/bbb_query_response/contract_response.dart';
import 'package:bbb_flutter/models/response/order_response_model.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter/foundation.dart';

enum BuildMode { release, debug, profile }

enum UnlockType { none, cloud, key }

enum EnvType { Pro, Test, Dev }

const Map<EnvType, String> envMap = {
  EnvType.Pro: "pro",
  EnvType.Test: "test",
  EnvType.Dev: "dev"
};

enum LockTimeType { lower, middle, high }

const Map<LockTimeType, int> UnlockTimes = {
  LockTimeType.lower: 300,
  LockTimeType.middle: 1200,
  LockTimeType.high: 3600,
};

enum MarketDuration { line, oneMin, fiveMin, oneHour, oneDay }
const Map<MarketDuration, String> marketDurationMap = {
  MarketDuration.line: "1m",
  MarketDuration.oneMin: "1m",
  MarketDuration.fiveMin: "5m",
  MarketDuration.oneHour: '1h',
  MarketDuration.oneDay: "1d",
};
const Map<MarketDuration, int> marketDurationSecondMap = {
  MarketDuration.line: 60,
  MarketDuration.oneMin: 60,
  MarketDuration.fiveMin: 300,
  MarketDuration.oneHour: 3600,
  MarketDuration.oneDay: 86400,
};

enum LoginType { none, cloud, key, test, reward }
const Map<LoginType, String> loginTypeStatusMap = {
  LoginType.none: "NONE",
  LoginType.cloud: "CLOUD",
  LoginType.key: "KEY",
  LoginType.test: "TEST",
  LoginType.reward: "REWARD",
};

enum OrderStatus { open, closed, rejected }
const Map<OrderStatus, String> orderStatusMap = {
  OrderStatus.open: "OPEN",
  OrderStatus.closed: "CLOSED",
  OrderStatus.rejected: "REJECTED",
};

enum ContractStatus { active, knocked_out }
const Map<ContractStatus, String> contractStatusMap = {
  ContractStatus.active: "ACTIVE",
  ContractStatus.knocked_out: "KNOCKED_OUT",
};

enum ActivityType { register, mainActivity }
const Map<ActivityType, int> activityTypes = {
  ActivityType.register: 0,
  ActivityType.mainActivity: 1
};

enum FundType {
  userDepositExtern,
  userWithdrawExtern,
  adminAdjust,
  userDepositCybex,
  userWithdrawCybex
}
const Map<String, FundType> fundTypeMap = {
  "gateway_deposit":
      FundType.userDepositExtern, //user deposits USDT from outside

  "gateway_withdraw":
      FundType.userWithdrawExtern, //user withdraws USDT to outside

  "ADMIN_ADJUST": FundType.adminAdjust, // admin fixes balance issue

  "transfer_in":
      FundType.userDepositCybex, // user deposits USDT from its cybex wallet

  "transfer_out":
      FundType.userWithdrawCybex, //user withdraws USDT to its cybex wallet
};

enum FundStatus { inProgress, rejected, completed, error }
const Map<FundStatus, String> fundStatusMap = {
  FundStatus.inProgress: "IN_PROGRESS",
  FundStatus.rejected: "REJECTED",
  FundStatus.completed: "COMPLETED",
  FundStatus.error: "ERROR",
};

String fundStatusCN(String status) {
  var map = {
    "IN_PROGRESS": I18n.of(globalKey.currentContext).fundStatusInProgress,
    "REJECTED": I18n.of(globalKey.currentContext).fundStatusRejected,
    "COMPLETED": I18n.of(globalKey.currentContext).fundStatusCompleted,
    "ERROR": I18n.of(globalKey.currentContext).fundStatusError,
  };

  return map[status];
}

String closeResonCN(String status) {
  var map = {
    "USER": I18n.of(globalKey.currentContext).userCloseOut,
    "CUTLOSS": I18n.of(globalKey.currentContext).cutLossCloseOut,
    "TAKEPROFIT": I18n.of(globalKey.currentContext).takeProfitCloseOut,
    "TIMEOVER": I18n.of(globalKey.currentContext).timeOverCloseOut,
  };

  return map[status];
}

String limitOrderStatusResonCN(String status) {
  var map = {
    "CANCELED": I18n.of(globalKey.currentContext).limitOrderStatusCanceled,
    "TRIGGERED": I18n.of(globalKey.currentContext).limitOrderStatusTriggered,
    "FAILED": I18n.of(globalKey.currentContext).limitOrderStatusFailed,
    "EXPIRED": I18n.of(globalKey.currentContext).limitOrderStatusExpired
  };

  return map[status];
}

///Route Types
class RouteParamsOfTrade {
  final Contract contract;
  final bool isUp;
  final String title;

  RouteParamsOfTrade(
      {this.contract, @required this.isUp, @required this.title});
}

class RouteParamsOfTransactionRecords {
  final OrderResponseModel orderResponseModel;

  RouteParamsOfTransactionRecords({@required this.orderResponseModel});
}

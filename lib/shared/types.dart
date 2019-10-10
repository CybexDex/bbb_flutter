import 'package:bbb_flutter/models/response/order_response_model.dart';
import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter/foundation.dart';

enum BuildMode { release, debug, profile }

enum UnlockType { none, cloud, key }

enum EnvType { Pro, Uat }

const Map<EnvType, String> envMap = {EnvType.Pro: "pro", EnvType.Uat: "uat"};

enum LockTimeType { lower, middle, high }

const Map<LockTimeType, int> UnlockTimes = {
  LockTimeType.lower: 300,
  LockTimeType.middle: 1200,
  LockTimeType.high: 3600,
};

enum MarketDuration { oneMin, fiveMin, oneHour, oneDay }
const Map<MarketDuration, String> marketDurationMap = {
  MarketDuration.oneMin: "1m",
  MarketDuration.fiveMin: "5m",
  MarketDuration.oneHour: '1h',
  MarketDuration.oneDay: "1d",
};
const Map<MarketDuration, int> marketDurationSecondMap = {
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
  "USER_DEPOSIT_EXTERN":
      FundType.userDepositExtern, //user deposits USDT from outside

  "USER_WITHDRAWAL_EXTERN":
      FundType.userWithdrawExtern, //user withdraws USDT to outside

  "ADMIN_ADJUST": FundType.adminAdjust, // admin fixes balance issue

  "USER_DEPOSIT_CYBEX":
      FundType.userDepositCybex, // user deposits USDT from its cybex wallet

  "USER_WITHDRAWAL_CYBEX":
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
    "USER_CLOSE_TIME_OVER": I18n.of(globalKey.currentContext).userCloseOut,
    "CUT_LOSS": I18n.of(globalKey.currentContext).cutLossCloseOut,
    "TAKE_PROFIT": I18n.of(globalKey.currentContext).takeProfitCloseOut,
  };

  return map[status];
}

///Route Types
class RouteParamsOfTrade {
  final Contract contract;
  final bool isUp;
  final String title;

  RouteParamsOfTrade(
      {@required this.contract, @required this.isUp, @required this.title});
}

class RouteParamsOfTransactionRecords {
  final OrderResponseModel orderResponseModel;

  RouteParamsOfTransactionRecords({@required this.orderResponseModel});
}

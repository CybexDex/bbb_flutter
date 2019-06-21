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

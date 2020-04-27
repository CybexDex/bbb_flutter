import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class RebateUserResponse {
  double latestRebate;
  double totalRebate;
  int currentEffectiveReferral;
  double rebateRatio;
  String title;
  int nextLevelReq;
  int levelId;
  int currentLevelTotal;

  RebateUserResponse(
      {this.latestRebate,
      this.totalRebate,
      this.currentEffectiveReferral,
      this.rebateRatio,
      this.title,
      this.nextLevelReq,
      this.levelId,
      this.currentLevelTotal});

  factory RebateUserResponse.fromJson(jsonRes) => jsonRes == null
      ? null
      : RebateUserResponse(
          latestRebate:
              convertValueByType(jsonRes['latest_rebate'], double, stack: "Root-latest_rebate"),
          totalRebate:
              convertValueByType(jsonRes['total_rebate'], double, stack: "Root-total_rebate"),
          currentEffectiveReferral: convertValueByType(jsonRes['current_effective_referral'], int,
              stack: "Root-current_effective_referral"),
          rebateRatio:
              convertValueByType(jsonRes['rebate_ratio'], double, stack: "Root-rebate_ratio"),
          title: convertValueByType(jsonRes['title'], String, stack: "Root-title"),
          nextLevelReq:
              convertValueByType(jsonRes['next_level_req'], int, stack: "Root-next_level_req"),
          levelId: convertValueByType(jsonRes['level_id'], int, stack: "Root-level_id"),
          currentLevelTotal: convertValueByType(jsonRes['current_level_total'], int,
              stack: "Root-current_level_total"));

  Map<String, dynamic> toJson() => {
        'latest_rebate': latestRebate,
        'total_rebate': totalRebate,
        'current_effective_referral': currentEffectiveReferral,
        'rebate_ratio': rebateRatio,
        'title': title,
        'next_level_req': nextLevelReq,
        'level_id': levelId,
        'current_level_total': currentLevelTotal
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class QueryRefResponseModel {
  bool success;
  Result result;

  QueryRefResponseModel({
    this.success,
    this.result,
  });

  factory QueryRefResponseModel.fromJson(jsonRes) => jsonRes == null
      ? null
      : QueryRefResponseModel(
          success: convertValueByType(jsonRes['success'], bool,
              stack: "Root-success"),
          result: Result.fromJson(jsonRes['result']),
        );

  Map<String, dynamic> toJson() => {
        'success': success,
        'result': result,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class Result {
  List<Referrers> referrers;
  List<Referrals> referrals;

  Result({
    this.referrers,
    this.referrals,
  });

  factory Result.fromJson(jsonRes) {
    if (jsonRes == null) return null;

    List<Referrers> referrers = jsonRes['referrers'] is List ? [] : null;
    if (referrers != null) {
      for (var item in jsonRes['referrers']) {
        if (item != null) {
          tryCatch(() {
            referrers.add(Referrers.fromJson(item));
          });
        }
      }
    }

    List<Referrals> referrals = jsonRes['referrals'] is List ? [] : null;
    if (referrals != null) {
      for (var item in jsonRes['referrals']) {
        if (item != null) {
          tryCatch(() {
            referrals.add(Referrals.fromJson(item));
          });
        }
      }
    }
    return Result(
      referrers: referrers,
      referrals: referrals,
    );
  }

  Map<String, dynamic> toJson() => {
        'referrers': referrers,
        'referrals': referrals,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class Referrers {
  String action;
  String referrer;

  Referrers({
    this.action,
    this.referrer,
  });

  factory Referrers.fromJson(jsonRes) => jsonRes == null
      ? null
      : Referrers(
          action: convertValueByType(jsonRes['action'], String,
              stack: "Referrers-action"),
          referrer: convertValueByType(jsonRes['referrer'], String,
              stack: "Referrers-referrer"),
        );

  Map<String, dynamic> toJson() => {
        'action': action,
        'referrer': referrer,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class Referrals {
  String action;
  List<ReferralList> referrals;

  Referrals({
    this.action,
    this.referrals,
  });

  factory Referrals.fromJson(jsonRes) {
    if (jsonRes == null) return null;

    List<ReferralList> referrals = jsonRes['referrals'] is List ? [] : null;
    if (referrals != null) {
      for (var item in jsonRes['referrals']) {
        if (item != null) {
          tryCatch(() {
            referrals.add(ReferralList.fromJson(item));
          });
        }
      }
    }
    return Referrals(
      action: convertValueByType(jsonRes['action'], String,
          stack: "Referrals-action"),
      referrals: referrals,
    );
  }

  Map<String, dynamic> toJson() => {
        'action': action,
        'referrals': referrals,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class ReferralList {
  String referral;
  int ts;

  ReferralList({
    this.referral,
    this.ts,
  });

  factory ReferralList.fromJson(jsonRes) => jsonRes == null
      ? null
      : ReferralList(
          referral: convertValueByType(jsonRes['referral'], String,
              stack: "Referrals-referral"),
          ts: convertValueByType(jsonRes['ts'], int, stack: "Referrals-ts"),
        );

  Map<String, dynamic> toJson() => {
        'referral': referral,
        'ts': ts,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

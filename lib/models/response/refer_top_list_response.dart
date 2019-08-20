import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class ReferTopListResponse {
  String asset;
  List<Top3> top3;
  User user;

  ReferTopListResponse({
    this.asset,
    this.top3,
    this.user,
  });

  factory ReferTopListResponse.fromJson(jsonRes) {
    if (jsonRes == null) return null;

    List<Top3> top3 = jsonRes['top3'] is List ? [] : null;
    if (top3 != null) {
      for (var item in jsonRes['top3']) {
        if (item != null) {
          tryCatch(() {
            top3.add(Top3.fromJson(item));
          });
        }
      }
    }
    return ReferTopListResponse(
      asset: convertValueByType(jsonRes['asset'], String, stack: "Root-asset"),
      top3: top3,
      user: User.fromJson(jsonRes['user']),
    );
  }

  Map<String, dynamic> toJson() => {
        'asset': asset,
        'top3': top3,
        'user': user,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class Top3 {
  double amount;
  String name;

  Top3({
    this.amount,
    this.name,
  });

  factory Top3.fromJson(jsonRes) => jsonRes == null
      ? null
      : Top3(
          amount: convertValueByType(jsonRes['amount'], double,
              stack: "Top3-amount"),
          name: convertValueByType(jsonRes['name'], String, stack: "Top3-name"),
        );

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'name': name,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class User {
  double total;
  double pending;

  User({
    this.total,
    this.pending,
  });

  factory User.fromJson(jsonRes) => jsonRes == null
      ? null
      : User(
          total:
              convertValueByType(jsonRes['total'], double, stack: "User-total"),
          pending: convertValueByType(jsonRes['pending'], double,
              stack: "User-pending"),
        );

  Map<String, dynamic> toJson() => {
        'total': total,
        'pending': pending,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

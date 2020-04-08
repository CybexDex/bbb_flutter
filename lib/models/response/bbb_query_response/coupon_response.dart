import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class CouponResponse {
  List<Coupon> coupon;

  CouponResponse({
    this.coupon,
  });

  factory CouponResponse.fromJson(jsonRes) {
    if (jsonRes == null) return null;

    List<Coupon> coupon = jsonRes['coupon'] is List ? [] : null;
    if (coupon != null) {
      for (var item in jsonRes['coupon']) {
        if (item != null) {
          coupon.add(Coupon.fromJson(item));
        }
      }
    }
    return CouponResponse(
      coupon: coupon,
    );
  }

  Map<String, dynamic> toJson() => {
        'coupon': coupon,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class Coupon {
  int id;
  String account;
  double amount;
  String actEffDate;
  String actExpDate;
  String actDate;
  String effDate;
  String expDate;
  String useDate;
  String createdAt;
  String status;
  Custom custom;

  Coupon({
    this.id,
    this.account,
    this.amount,
    this.actEffDate,
    this.actExpDate,
    this.actDate,
    this.effDate,
    this.expDate,
    this.useDate,
    this.createdAt,
    this.status,
    this.custom,
  });

  factory Coupon.fromJson(jsonRes) => jsonRes == null
      ? null
      : Coupon(
          id: convertValueByType(jsonRes['id'], int, stack: "Coupon-id"),
          account: convertValueByType(jsonRes['account'], String, stack: "Coupon-account"),
          amount: convertValueByType(jsonRes['amount'], double, stack: "Coupon-amount"),
          actEffDate:
              convertValueByType(jsonRes['act_eff_date'], String, stack: "Coupon-act_eff_date"),
          actExpDate:
              convertValueByType(jsonRes['act_exp_date'], String, stack: "Coupon-act_exp_date"),
          actDate: convertValueByType(jsonRes['act_date'], String, stack: "Coupon-act_date"),
          effDate: convertValueByType(jsonRes['eff_date'], String, stack: "Coupon-eff_date"),
          expDate: convertValueByType(jsonRes['exp_date'], String, stack: "Coupon-exp_date"),
          useDate: convertValueByType(jsonRes['use_date'], String, stack: "Coupon-use_date"),
          createdAt: convertValueByType(jsonRes['created_at'], String, stack: "Coupon-created_at"),
          status: convertValueByType(jsonRes['status'], String, stack: "Coupon-status"),
          custom: Custom.fromJson(jsonRes['custom'] == ""
              ? null
              : json.decode(
                  convertValueByType(jsonRes['custom'], String, stack: "Coupon-status"),
                )));

  Map<String, dynamic> toJson() => {
        'id': id,
        'account': account,
        'amount': amount,
        'act_eff_date': actEffDate,
        'act_exp_date': actExpDate,
        'act_date': actDate,
        'eff_date': effDate,
        'exp_date': expDate,
        'use_date': useDate,
        'created_at': createdAt,
        'status': status,
        'custom': custom,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class Custom {
  String description;
  bool humanActivate;
  String wechatId;
  String type;

  Custom({
    this.description,
    this.humanActivate,
    this.wechatId,
    this.type,
  });

  factory Custom.fromJson(jsonRes) => jsonRes == null
      ? null
      : Custom(
          description:
              convertValueByType(jsonRes['description'], String, stack: "Root-description"),
          humanActivate:
              convertValueByType(jsonRes['human_activate'], bool, stack: "Root-human_activate"),
          wechatId: convertValueByType(jsonRes['wechat_id'], String, stack: "Root-wechat_id"),
          type: convertValueByType(jsonRes['type'], String, stack: "Root-type"),
        );

  Map<String, dynamic> toJson() => {
        'description': description,
        'human_activate': humanActivate,
        'wechat_id': wechatId,
        'type': type,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

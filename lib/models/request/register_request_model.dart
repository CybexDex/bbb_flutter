import 'dart:convert';

class RegisterRequestModel {
  Cap cap;
  Account account;

  RegisterRequestModel({
    this.cap,
    this.account,
  });

  factory RegisterRequestModel.fromRawJson(String str) =>
      RegisterRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) =>
      new RegisterRequestModel(
        cap: Cap.fromJson(json["cap"]),
        account: Account.fromJson(json["account"]),
      );

  Map<String, dynamic> toJson() => {
        "cap": cap.toJson(),
        "account": account.toJson(),
      };
}

class Account {
  String ownerKey;
  dynamic referrer;
  String memoKey;
  String name;
  dynamic refcode;
  String activeKey;

  Account({
    this.ownerKey,
    this.referrer,
    this.memoKey,
    this.name,
    this.refcode,
    this.activeKey,
  });

  factory Account.fromRawJson(String str) => Account.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Account.fromJson(Map<String, dynamic> json) => new Account(
        ownerKey: json["owner_key"],
        referrer: json["referrer"],
        memoKey: json["memo_key"],
        name: json["name"],
        refcode: json["refcode"],
        activeKey: json["active_key"],
      );

  Map<String, dynamic> toJson() => {
        "owner_key": ownerKey,
        "referrer": referrer,
        "memo_key": memoKey,
        "name": name,
        "refcode": refcode,
        "active_key": activeKey,
      };
}

class Cap {
  String captcha;
  String id;

  Cap({
    this.captcha,
    this.id,
  });

  factory Cap.fromRawJson(String str) => Cap.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Cap.fromJson(Map<String, dynamic> json) => new Cap(
        captcha: json["captcha"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "captcha": captcha,
        "id": id,
      };
}

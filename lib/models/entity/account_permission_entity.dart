import 'dart:convert';

class AccountPermissionEntity {
  bool unlock;
  bool withdraw;
  bool trade;
  String defaultKey;

  AccountPermissionEntity(
      {this.unlock, this.defaultKey, this.trade, this.withdraw});

  factory AccountPermissionEntity.fromRawJson(String str) =>
      AccountPermissionEntity.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AccountPermissionEntity.fromJson(Map<String, dynamic> json) =>
      new AccountPermissionEntity(
          defaultKey: json["default_key"],
          trade: json["trade"],
          unlock: json["unlock"],
          withdraw: json["withdraw"]);

  Map<String, dynamic> toJson() => {
        "default_key": defaultKey,
        "unlock": unlock,
        "trade": trade,
        "withdraw": withdraw,
      };
}

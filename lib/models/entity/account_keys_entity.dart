// To parse this JSON data, do
//
//     final accountKeysEntity = accountKeysEntityFromJson(jsonString);

import 'dart:convert';

class AccountKeysEntity {
  Key ownerKey;
  Key activeKey;
  Key memoKey;

  AccountKeysEntity({
    this.ownerKey,
    this.activeKey,
    this.memoKey,
  });

  List<String> get pubkeys {
    return keys.map((key) => key.publicKey).toList();
  }

  List<Key> get keys {
    return [
      if (activeKey != null) activeKey,
      if (ownerKey != null) ownerKey,
      if (memoKey != null) memoKey,
    ];
  }

  void removePrivateKey() {
    if (memoKey != null) {
      memoKey.privateKey = null;
    }
    if (ownerKey != null) {
      ownerKey.privateKey = null;
    }
    if (activeKey != null) {
      activeKey.privateKey = null;
    }
  }

  factory AccountKeysEntity.fromRawJson(String str) =>
      AccountKeysEntity.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AccountKeysEntity.fromJson(Map<String, dynamic> json) =>
      new AccountKeysEntity(
        ownerKey: Key.fromJson(json["owner-key"]),
        activeKey: Key.fromJson(json["active-key"]),
        memoKey: Key.fromJson(json["memo-key"]),
      );

  Map<String, dynamic> toJson() => {
        "owner-key": ownerKey.toJson(),
        "active-key": activeKey.toJson(),
        "memo-key": memoKey.toJson(),
      };
}

class Key {
  String compressed;
  String uncompressed;
  String privateKey;
  String publicKey;
  String address;

  Key({
    this.compressed,
    this.uncompressed,
    this.privateKey,
    this.publicKey,
    this.address,
  });

  factory Key.fromRawJson(String str) => Key.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Key.fromJson(Map<String, dynamic> json) => new Key(
        compressed: json["compressed"],
        uncompressed: json["uncompressed"],
        privateKey: json["private_key"],
        publicKey: json["public_key"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "compressed": compressed,
        "uncompressed": uncompressed,
        "private_key": privateKey,
        "public_key": publicKey,
        "address": address,
      };
}

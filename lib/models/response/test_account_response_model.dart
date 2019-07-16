import 'dart:convert' show json;

class TestAccountResponseModel {
  String accountName;
  String accountId;
  String privateKey;
  String publicKey;

  TestAccountResponseModel({
    this.accountName,
    this.accountId,
    this.privateKey,
    this.publicKey,
  });

  factory TestAccountResponseModel.fromJson(jsonRes) => jsonRes == null
      ? null
      : TestAccountResponseModel(
          accountName: jsonRes['accountName'],
          accountId: jsonRes['accountId'],
          privateKey: jsonRes['privateKey'],
          publicKey: jsonRes['publicKey'],
        );

  Map<String, dynamic> toJson() => {
        'accountName': accountName,
        'accountId': accountId,
        'privateKey': privateKey,
        'publicKey': publicKey,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

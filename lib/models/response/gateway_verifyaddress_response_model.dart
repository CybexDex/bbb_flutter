import 'dart:convert' show json;

class VerifyAddressResponseModel {
  String address;
  String asset;
  int timestamp;
  bool valid;

  VerifyAddressResponseModel({
    this.address,
    this.asset,
    this.timestamp,
    this.valid,
  });

  factory VerifyAddressResponseModel.fromJson(jsonRes) => jsonRes == null
      ? null
      : VerifyAddressResponseModel(
          address: jsonRes['address'],
          asset: jsonRes['asset'],
          timestamp: jsonRes['timestamp'],
          valid: jsonRes['valid'],
        );

  Map<String, dynamic> toJson() => {
        'address': address,
        'asset': asset,
        'timestamp': timestamp,
        'valid': valid,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

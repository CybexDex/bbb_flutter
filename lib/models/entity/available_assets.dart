import 'dart:convert';

class AvailableAsset {
  String assetName;
  String assetId;
  int precision;

  AvailableAsset({
    this.assetName,
    this.assetId,
    this.precision,
  });

  factory AvailableAsset.fromRawJson(String str) =>
      AvailableAsset.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AvailableAsset.fromJson(Map<String, dynamic> json) =>
      new AvailableAsset(
        assetName: json["assetName"],
        assetId: json["assetId"],
        precision: json["precision"],
      );

  Map<String, dynamic> toJson() => {
        "assetName": assetName,
        "assetId": assetId,
        "precision": precision,
      };
}

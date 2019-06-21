import 'dart:convert';

class PositionsResponseModel {
  String accountName;
  List<Position> positions;
  DateTime time;

  PositionsResponseModel({
    this.accountName,
    this.positions,
    this.time,
  });

  factory PositionsResponseModel.fromRawJson(String str) =>
      PositionsResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PositionsResponseModel.fromJson(Map<String, dynamic> json) =>
      new PositionsResponseModel(
        accountName: json["accountName"],
        positions: new List<Position>.from(
            json["positions"].map((x) => Position.fromJson(x))),
        time: DateTime.parse(json["time"]),
      );

  Map<String, dynamic> toJson() => {
        "accountName": accountName,
        "positions": new List<dynamic>.from(positions.map((x) => x.toJson())),
        "time": time.toIso8601String(),
      };
}

class Position {
  String assetName;
  String assetId;
  double quantity;

  Position({
    this.assetName,
    this.assetId,
    this.quantity,
  });

  factory Position.fromRawJson(String str) =>
      Position.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Position.fromJson(Map<String, dynamic> json) => new Position(
        assetName: json["assetName"],
        assetId: json["assetId"],
        quantity: json["quantity"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "assetName": assetName,
        "assetId": assetId,
        "quantity": quantity,
      };
}

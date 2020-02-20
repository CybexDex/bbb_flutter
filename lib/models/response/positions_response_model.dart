import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class PositionsResponseModel {
  String accountName;
  List<Position> positions;

  PositionsResponseModel({
    this.accountName,
    this.positions,
  });

  factory PositionsResponseModel.fromJson(jsonRes) {
    if (jsonRes == null) return null;

    List<Position> positions = jsonRes['positions'] is List ? [] : null;
    if (positions != null) {
      for (var item in jsonRes['positions']) {
        if (item != null) {
          positions.add(Position.fromJson(item));
        }
      }
    }
    return PositionsResponseModel(
      accountName: convertValueByType(jsonRes['accountName'], String,
          stack: "Root-accountName"),
      positions: positions,
    );
  }

  Map<String, dynamic> toJson() => {
        'accountName': accountName,
        'positions': positions,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class Position {
  String assetId;
  double quantity;

  Position({
    this.assetId,
    this.quantity,
  });

  factory Position.fromJson(jsonRes) => jsonRes == null
      ? null
      : Position(
          assetId: convertValueByType(jsonRes['assetId'], String,
              stack: "Positions-assetId"),
          quantity: jsonRes['quantity'],
        );

  Map<String, dynamic> toJson() => {
        'assetId': assetId,
        'quantity': quantity,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

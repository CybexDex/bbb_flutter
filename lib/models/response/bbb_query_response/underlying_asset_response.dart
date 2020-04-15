import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class UnderlyingAssetResponse {
  String underlying;
  double priceFloating;

  UnderlyingAssetResponse({
    this.underlying,
    this.priceFloating,
  });

  factory UnderlyingAssetResponse.fromJson(jsonRes) => jsonRes == null
      ? null
      : UnderlyingAssetResponse(
          underlying: convertValueByType(jsonRes['underlying'], String, stack: "Root-underlying"),
          priceFloating:
              convertValueByType(jsonRes['price_floating'], double, stack: "Root-price_floating"),
        );

  Map<String, dynamic> toJson() => {
        'underlying': underlying,
        'price_floating': priceFloating,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

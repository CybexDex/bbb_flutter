import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class AssetList {
  int updated;
  String seq;
  String symbol;
  int created;

  AssetList({
    this.updated,
    this.seq,
    this.symbol,
    this.created,
  });

  factory AssetList.fromJson(jsonRes) => jsonRes == null
      ? null
      : AssetList(
          updated: convertValueByType(jsonRes['updated'], int,
              stack: "Root-updated"),
          seq: convertValueByType(jsonRes['seq'], String, stack: "Root-seq"),
          symbol: convertValueByType(jsonRes['symbol'], String,
              stack: "Root-symbol"),
          created: convertValueByType(jsonRes['created'], int,
              stack: "Root-created"),
        );

  Map<String, dynamic> toJson() => {
        'updated': updated,
        'seq': seq,
        'symbol': symbol,
        'created': created,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class TestAccountResponseModel {
  int code;
  String name;
  String privkey;

  TestAccountResponseModel({
    this.code,
    this.name,
    this.privkey,
  });

  factory TestAccountResponseModel.fromJson(jsonRes) => jsonRes == null
      ? null
      : TestAccountResponseModel(
          code: convertValueByType(jsonRes['code'], int, stack: "Root-code"),
          name: convertValueByType(jsonRes['name'], String, stack: "Root-name"),
          privkey: convertValueByType(jsonRes['privkey'], String,
              stack: "Root-privkey"),
        );

  Map<String, dynamic> toJson() => {
        'code': code,
        'name': name,
        'privkey': privkey,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

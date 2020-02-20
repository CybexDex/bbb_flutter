import 'dart:convert' show json;

import 'package:bbb_flutter/helper/error_code_translator.dart';
import 'package:bbb_flutter/helper/utils.dart';
import 'package:bbb_flutter/shared/ui_common.dart';

class PostOrderResponseModel {
  int code;
  String msg;

  PostOrderResponseModel({
    this.code,
    this.msg,
  });

  factory PostOrderResponseModel.fromJson(jsonRes) => jsonRes == null
      ? null
      : PostOrderResponseModel(
          code: convertValueByType(jsonRes['code'], int, stack: "Root-code"),
          msg: translatePostOrderResponseErrorCode(
              code: jsonRes['code'] != null ? jsonRes['code'] : null,
              context: globalKey.currentContext),
        );

  Map<String, dynamic> toJson() => {
        'code': code,
        'msg': msg,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

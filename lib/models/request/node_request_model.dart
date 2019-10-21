import 'dart:convert' show json;

import 'package:bbb_flutter/helper/utils.dart';

class NodeRequestModel<T> {
  String jsonrpc;
  String method;
  List<T> params;
  int id;

  NodeRequestModel({
    this.jsonrpc = "2.0",
    this.method,
    this.params,
    this.id = 1,
  });

  factory NodeRequestModel.fromJson(jsonRes) {
    if (jsonRes == null) return null;

    List<T> params = jsonRes['params'] is List ? [] : null;
    if (params != null) {
      for (var item in jsonRes['params']) {
        if (item != null) {
          tryCatch(() {
            params.add(item);
          });
        }
      }
    }
    return NodeRequestModel(
      jsonrpc:
          convertValueByType(jsonRes['jsonrpc'], String, stack: "Root-jsonrpc"),
      method:
          convertValueByType(jsonRes['method'], String, stack: "Root-method"),
      params: params,
      id: convertValueByType(jsonRes['id'], int, stack: "Root-id"),
    );
  }

  Map<String, dynamic> toJson() => {
        'jsonrpc': jsonrpc,
        'method': method,
        'params': params,
        'id': id,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

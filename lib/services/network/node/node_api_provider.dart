import 'dart:convert';

import 'package:bbb_flutter/cache/shared_pref.dart';
import 'package:bbb_flutter/models/request/node_request_model.dart';
import 'package:bbb_flutter/models/response/node_response_model.dart';
import 'package:bbb_flutter/models/response/node_top_list_response_model.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:dio/dio.dart';

import 'node_api.dart';

class NodeApiProvider extends NodeApi {
  Dio dio = Dio();
  SharedPref _pref;

  NodeApiProvider({SharedPref sharedPref}) {
    _pref = sharedPref;
    _dispatchNode();
    dio.options.connectTimeout = 15000; //5s
    dio.options.receiveTimeout = 13000;
  }

  _dispatchNode() {
    if (_pref.getEnvType() == EnvType.Pro) {
      dio.options.baseUrl = NodeConnection.PRO_NODE;
    } else if (_pref.getEnvType() == EnvType.Test) {
      dio.options.baseUrl = NodeConnection.UAT_NODE;
    } else {
      dio.options.baseUrl = NodeConnection.PRO_NODE;
    }
  }

  @override
  setEnvMode({EnvType envType}) async {
    await _pref.saveEnvType(envType: envType);
    _dispatchNode();
  }

  @override
  Future<NodeResponose<int>> getTotalTransfer(
      {NodeRequestModel<String> nodeRequestModel}) async {
    var response = await dio.post("", data: nodeRequestModel.toJson());
    var responseData = json.decode(response.data);
    return Future.value(NodeResponose.fromJson(responseData));
  }

  @override
  Future<NodeResponose<NodeTopListResponse>> getTopTransferByFromAssetHuman(
      {NodeRequestModel<String> nodeRequestModel}) async {
    var response = await dio.post("", data: nodeRequestModel.toJson());
    var responseData = json.decode(response.data);
    return Future.value(NodeResponose.fromJson(responseData));
  }
}

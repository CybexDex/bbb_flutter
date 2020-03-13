import 'dart:convert';

import 'package:bbb_flutter/cache/shared_pref.dart';
import 'package:bbb_flutter/models/request/post_ref_request_model.dart';
import 'package:bbb_flutter/models/response/query_ref_response_model.dart';
import 'package:bbb_flutter/models/response/refer_top_list_response.dart';
import 'package:bbb_flutter/models/response/register_ref_response_model.dart';
import 'package:bbb_flutter/services/network/refer/refer_api.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:dio/dio.dart';

class ReferApiProvider extends ReferApi {
  Dio dio = Dio();
  SharedPref _pref;

  ReferApiProvider({SharedPref sharedPref}) {
    _pref = sharedPref;
    _dispatchNode();
    dio.options.connectTimeout = 15000; //5s
    dio.options.receiveTimeout = 13000;
  }

  _dispatchNode() {
    if (_pref.getEnvType() == EnvType.Pro) {
      dio.options.baseUrl = ReferSystemConnection.PRO_REFER;
    } else if (_pref.getEnvType() == EnvType.Test) {
      dio.options.baseUrl = ReferSystemConnection.TEST_REFER;
    } else {
      dio.options.baseUrl = ReferSystemConnection.PRO_REFER;
    }
  }

  @override
  setEnvMode({EnvType envType}) async {
    await _pref.saveEnvType(envType: envType);
    _dispatchNode();
  }

  @override
  Future<RegisterRefResponseModel> registerRef(
      {PostRefRequestModel postRefRequestModel}) async {
    var response =
        await dio.post("/refer/", data: postRefRequestModel.toJson());
    var responseData = json.decode(response.data);
    return Future.value(RegisterRefResponseModel.fromJson(responseData));
  }

  @override
  Future<QueryRefResponseModel> queryRef({String accountName}) async {
    var response =
        await dio.get("/refer/?account=$accountName&action=$ReferAction");
    var responseData = json.decode(response.data);
    return Future.value(QueryRefResponseModel.fromJson(responseData));
  }

  @override
  Future<ReferTopListResponse> getTopList({String accountName}) async {
    var response = await dio.get("/bbb/?account=$accountName");
    var responseData = json.decode(response.data);
    return Future.value(ReferTopListResponse.fromJson(responseData));
  }
}

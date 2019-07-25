import 'dart:convert';

import 'package:bbb_flutter/models/request/post_ref_request_model.dart';
import 'package:bbb_flutter/models/response/query_ref_response_model.dart';
import 'package:bbb_flutter/models/response/register_ref_response_model.dart';
import 'package:bbb_flutter/services/network/refer/refer_api.dart';
import 'package:dio/dio.dart';

class ReferApiProvider extends ReferApi {
  Dio dio = Dio();

  ReferApiProvider() {
    dio.options.baseUrl = "https://refer.cybex.io";
    dio.options.connectTimeout = 5000; //5s
    dio.options.receiveTimeout = 3000;
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
    var response = await dio.get("/refer/?account=$accountName&action=bbbtest");
    var responseData = json.decode(response.data);
    return Future.value(QueryRefResponseModel.fromJson(responseData));
  }
}

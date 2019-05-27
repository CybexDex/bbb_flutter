import 'dart:convert';

import 'package:bbb_flutter/models/request/amend_order_request_model.dart';
import 'package:bbb_flutter/models/request/post_order_request_model.dart';
import 'package:bbb_flutter/models/response/account_response_model.dart';
import 'package:bbb_flutter/models/response/market_history_response_model.dart';
import 'package:bbb_flutter/models/response/order_response_model.dart';
import 'package:bbb_flutter/models/response/positions_response_model.dart';
import 'package:bbb_flutter/models/response/post_order_response_model.dart';
import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
import 'package:bbb_flutter/services/network/BBB/bbb_api.dart';
import 'package:dio/dio.dart';

import '../../../env.dart';

class BBBAPIProvider extends BBBAPI {
  factory BBBAPIProvider() => _sharedInstance();

  static BBBAPIProvider _sharedInstance() {
    if (_instance == null) {
      _instance = BBBAPIProvider._();
    }
    return _instance;
  }

  static BBBAPIProvider _instance;

  Dio dio = Dio();

  BBBAPIProvider._() {
    dio.options.baseUrl = "https://nxapitest.cybex.io/v1";
    dio.options.connectTimeout = 5000; //5s
    dio.options.receiveTimeout = 3000;
  }

  @override
  Future<RefContractResponseModel> getRefData() async {
    var response = await dio.get('/refData');
    return Future.value(RefContractResponseModel.fromJson(response.data));
  }

  @override
  Future<PositionsResponseModel> getPositions({String name}) async {
    var response = await dio.get('/position?accountName=$name');
    return Future.value(PositionsResponseModel.fromJson(response.data));
  }

  @override
  Future<List<OrderResponseModel>> getOrders({String name}) async {
    var response = await dio.get('/order?accountName=$name');
    var responseData = json.decode(response.data) as List;
    log.info(responseData.toString());
    List<OrderResponseModel> model =
        responseData.map((data) => OrderResponseModel.fromJson(data)).toList();

    return Future.value(model);
  }

  Future<List<MarketHistoryResponseModel>> getMarketHistory(
      {String startTime, String endTime, String asset}) async {
    var response = await dio
        .get('/ticker?startTime=$startTime&endTime=$endTime&asset=$asset');
    var responseData = json.decode(response.data) as List;
    log.info(responseData.toString());
    List<MarketHistoryResponseModel> model = responseData.map((data) {
      var model = MarketHistoryResponseModel();
      model.xts = data[0];
      model.px = double.parse(data[1]);
      return model;
    }).toList();

//    responseData
//        .map((data) {
//          var model = MarketHistoryResponseModel();
//          model.xts = data[0];
//          model.px = double.parse(data[1]);
//          return model;
//        });
    return Future.value(model);
  }

  @override
  Future<PostOrderResponseModel> amendOrder(
      {AmendOrderRequestModel order}) async {
    var response = await dio.post("/transaction");
    return Future.value(PostOrderResponseModel.fromJson(response.data));
  }

  @override
  Future<PostOrderResponseModel> postOrder(
      {PostOrderRequestModel order}) async {
    var response = await dio.post("/transaction");
    return Future.value(PostOrderResponseModel.fromJson(response.data));
  }

  @override
  Future<AccountResponseModel> getAccount({String name}) async {
    var response = await dio.get("/account?accountName=$name");
    return Future.value(AccountResponseModel.fromJson(response.data["result"]));
  }
}

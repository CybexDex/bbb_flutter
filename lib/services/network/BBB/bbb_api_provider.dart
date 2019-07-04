import 'dart:convert';

import 'package:bbb_flutter/helper/common_utils.dart';
import 'package:bbb_flutter/interceptors.dart';
import 'package:bbb_flutter/models/request/amend_order_request_model.dart';
import 'package:bbb_flutter/models/request/post_order_request_model.dart';
import 'package:bbb_flutter/models/response/account_response_model.dart';
import 'package:bbb_flutter/models/response/fund_record_model.dart';
import 'package:bbb_flutter/models/response/market_history_response_model.dart';
import 'package:bbb_flutter/models/response/order_response_model.dart';
import 'package:bbb_flutter/models/response/positions_response_model.dart';
import 'package:bbb_flutter/models/response/post_order_response_model.dart';
import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
import 'package:bbb_flutter/services/network/BBB/bbb_api.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:dio/dio.dart';
import 'package:bbb_flutter/models/response/deposit_response_model.dart';

class BBBAPIProvider extends BBBAPI {
  Dio dio = Dio();

  BBBAPIProvider() {
    dio.options.baseUrl = "https://nxapitest.cybex.io/v1";
    dio.options.connectTimeout = 15000;
    dio.options.receiveTimeout = 13000;
    // dio.interceptors.add(ILogInterceptor(
    //     responseBody: true,
    //     requestHeader: false,
    //     request: true,
    //     responseHeader: false));
  }

  @override
  Future<RefContractResponseModel> getRefData() async {
    var response = await dio.get('/refData');
    var responseData = json.decode(response.data);
    return Future.value(RefContractResponseModel.fromJson(responseData));
  }

  @override
  Future<PositionsResponseModel> getPositions({String name}) async {
    var response = await dio.get('/position?accountName=$name');
    var responseData = json.decode(response.data);
    return Future.value(PositionsResponseModel.fromJson(responseData));
  }

  @override
  Future<List<OrderResponseModel>> getOrders(String name,
      {List<OrderStatus> status}) async {
    var params = {"accountName": name};

    if (!isAllEmpty(status)) {
      final statusValue = status.map((s) => orderStatusMap[s]).join(",");
      params["status"] = statusValue;
    }

    var response = await dio.get('/order', queryParameters: params);
    var responseData = json.decode(response.data) as List;
    if (responseData == null) {
      return Future.value([]);
    }
    List<OrderResponseModel> model =
        responseData.map((data) => OrderResponseModel.fromJson(data)).toList();

    return Future.value(model);
  }

  @override
  Future<List<FundRecordModel>> getFundRecords(
      {String name, DateTime start, DateTime end}) async {
    var response = await dio
        .get("/fund", queryParameters: {"startTime": "", "endTime": ""});
    var responseData = json.decode(response.data) as List;
    List<FundRecordModel> model = responseData.map((data) {
      return FundRecordModel.fromJson(data);
    }).toList();
    return model;
  }

  //assetName=BXBT&interval=1m&startTime=1561453047&endTime=1561453347
  Future<List<MarketHistoryResponseModel>> getMarketHistory(
      {String startTime, String endTime, String asset}) async {
    var response = await dio.get(
        '/klines?assetName=$asset&interval=1m&startTime=$startTime&endTime=$endTime&limit=300');
    var responseData = json.decode(response.data) as List;
    List<MarketHistoryResponseModel> model = responseData.map((data) {
      var model = MarketHistoryResponseModel();
      model.xts = data[0] * 1000000;
      model.px = data[4];
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
  Future<DepositResponseModel> getDeposit({String name, String asset}) async {
    var response = await dio.get('/depositAddress',
        queryParameters: {"accountName": name, "asset": asset});
    var responseData = json.decode(response.data);
    return Future.value(DepositResponseModel.fromJson(responseData));
  }

  @override
  Future<PostOrderResponseModel> amendOrder(
      {AmendOrderRequestModel order}) async {
    var response = await dio.post("/transaction", data: order.toJson());
    var responseData = json.decode(response.data);

    return Future.value(PostOrderResponseModel.fromJson(responseData));
  }

  @override
  Future<PostOrderResponseModel> postOrder(
      {PostOrderRequestModel order}) async {
    var response = await dio.post("/transaction", data: order.toJson());
    var responseData = json.decode(response.data);
    return Future.value(PostOrderResponseModel.fromJson(responseData));
  }

  @override
  Future<AccountResponseModel> getAccount({String name}) async {
    var response = await dio.get("/account?accountName=$name");
    var responseData = json.decode(response.data);
    return Future.value(responseData["result"] == null
        ? null
        : AccountResponseModel.fromJson(responseData["result"]));
  }
}

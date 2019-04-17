import 'package:bbb_flutter/models/response/market_history_response_model.dart';
import 'package:bbb_flutter/models/response/order_response_model.dart';
import 'package:bbb_flutter/models/response/positions_response_model.dart';
import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
import 'package:bbb_flutter/services/BBBAPI.dart';
import 'package:dio/dio.dart';

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
    var responseData = response.data as List<Map<String, dynamic>>;
    List<OrderResponseModel> model = responseData
        .map((data) => OrderResponseModel.fromJson(data))
        .toList()
        .toList();

    return Future.value(model);
  }

  Future<List<MarketHistoryResponseModel>> getMarketHistory(
      {String startTime, String endTime, String asset}) async {
    var response = await dio
        .get('/ticker?startTime=$startTime&endTime=$endTime&asset=$asset');
    var responseData = response.data as List<List>;
    List<MarketHistoryResponseModel> model = responseData
        .map((data) {
          var model = MarketHistoryResponseModel();
          model.xts = data[0];
          model.px = data[1];
          return model;
        })
        .toList()
        .toList();
    return Future.value(model);
  }
}

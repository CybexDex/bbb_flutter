import 'package:bbb_flutter/cache/shared_pref.dart';
import 'package:bbb_flutter/helper/common_utils.dart';
import 'package:bbb_flutter/helper/utils.dart';
import 'package:bbb_flutter/models/request/amend_order_request_model.dart';
import 'package:bbb_flutter/models/response/account_response_model.dart';
import 'package:bbb_flutter/models/response/bbb_query_response/action_response.dart';
import 'package:bbb_flutter/models/response/bbb_query_response/contract_response.dart';
import 'package:bbb_flutter/models/response/bbb_query_response/refData_response.dart';
import 'package:bbb_flutter/models/response/fund_record_model.dart';
import 'package:bbb_flutter/models/response/market_history_response_model.dart';
import 'package:bbb_flutter/models/response/order_response_model.dart';
import 'package:bbb_flutter/models/response/positions_response_model.dart';
import 'package:bbb_flutter/models/response/post_order_response_model.dart';
import 'package:bbb_flutter/models/response/ranking_response_model.dart';
import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
import 'package:bbb_flutter/models/response/test_account_response_model.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/widgets/k_line/entity/k_line_entity.dart';
import 'package:dio/dio.dart';
import 'package:bbb_flutter/models/response/deposit_response_model.dart';

class BBBAPIProvider extends BBBAPI {
  Dio dio = Dio();
  SharedPref _pref;
  Dio newDio = Dio();
  String action = "main";

  BBBAPIProvider({SharedPref sharedPref}) {
    _pref = sharedPref;
    _dispatchNode();
    _dispatchNewNode();
    dio.options.connectTimeout = 15000;
    dio.options.receiveTimeout = 13000;
  }

  @override
  setTestNet({bool isTestNet}) async {
    await _pref.saveTestNet(isTestNet: isTestNet);
    _dispatchNode();
  }

  @override
  setEnvMode({EnvType envType}) async {
    await _pref.saveEnvType(envType: envType);
    _dispatchNode();
  }

  @override
  setAction({String action}) async {
    await _pref.saveAction(action: action);
    this.action = action;
  }

  _dispatchNode() {
    if (_pref.getEnvType() == EnvType.Pro) {
      dio.options.baseUrl = _pref.getTestNet()
          ? NetworkConnection.PRO_TESTNET
          : NetworkConnection.PRO_STANDARD;
    } else if (_pref.getEnvType() == EnvType.Uat) {
      dio.options.baseUrl = _pref.getTestNet()
          ? NetworkConnection.UAT_TESTNET
          : NetworkConnection.UAT_STANDARD;
    }
  }

  _dispatchNewNode() {
    newDio.options.baseUrl = BBBApiConnection.PRO;
    action = _pref.getAction();
  }

  @override
  Future<RefContractResponseModel> getRefData(
      {List<ContractStatus> status}) async {
    var params = Map<String, dynamic>();
    if (!isAllEmpty(status)) {
      final statusValue = status.map((s) => contractStatusMap[s]).join(",");
      params["contractStatus"] = statusValue;
    }
    var response = await dio.get('/refData', queryParameters: params);
    return Future.value(RefContractResponseModel.fromJson(response.data));
  }

  @override
  Future<ActionResponse> getActions() async {
    var response = await newDio.get('/actions?active=1');
    return Future.value(ActionResponse.fromJson(response.data));
  }

  @override
  Future<RefDataResponse> getRefDataNew({String injectAction}) async {
    var response = await newDio
        .get('/refdata?action=${injectAction == null ? action : injectAction}');
    return Future.value(RefDataResponse.fromJson(response.data));
  }

  @override
  Future<ContractResponse> getContract() async {
    var response = await newDio.get('/contracts?action=$action');
    Map<String, dynamic> convertedResult = convertJson(response.data);
    return Future.value(ContractResponse.fromJson(convertedResult));
  }

  @override
  Future<PositionsResponseModel> getPositions(
      {String name, String injectAction}) async {
    var response = await newDio.get(
        '/position?accountName=$name&action=${injectAction == null ? action : injectAction}');
    return Future.value(PositionsResponseModel.fromJson(response.data));
  }

  @override
  Future<PositionsResponseModel> getPositionsTestAccount({String name}) async {
    Dio singleDio = Dio();
    if (_pref.getEnvType() == EnvType.Pro) {
      singleDio.options.baseUrl = NetworkConnection.PRO_TESTNET;
    } else if (_pref.getEnvType() == EnvType.Uat) {
      singleDio.options.baseUrl = NetworkConnection.UAT_TESTNET;
    }
    var response = await singleDio.get('/position?accountName=$name');
    return Future.value(PositionsResponseModel.fromJson(response.data));
  }

  @override
  Future<List<OrderResponseModel>> getOrders(String name,
      {List<OrderStatus> status, String startTime, String endTime}) async {
    var params = {
      "accountName": name,
    };

    if (!isAllEmpty(status)) {
      final statusValue = status.map((s) => orderStatusMap[s]).join(",");
      params["status"] = statusValue;
    }

    if (startTime != null && endTime != null) {
      params["beginTime"] = startTime;
      params["endTime"] = endTime;
    }
    params["action"] = action;

    var response = await newDio.get('/order', queryParameters: params);
    var responseData = response.data as List;
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
    var response = await newDio
        .get("/fund", queryParameters: {"accountName": name, "action": action});
    var responseData = response.data as List;
    List<FundRecordModel> model = responseData.map((data) {
      return FundRecordModel.fromJson(data);
    }).toList();
    return Future.value(model);
  }

  @override
  Future<List<RankingResponse>> getRankings({int indicator}) async {
    var response =
        await newDio.get("/ranking", queryParameters: {"indicator": indicator});
    var responseData = response.data as List;
    if (responseData == null) {
      return Future.value([]);
    }
    List<RankingResponse> model = responseData.map((data) {
      return RankingResponse.fromJson(data);
    }).toList();
    return Future.value(model);
  }

  //assetName=BXBT&interval=1m&startTime=1561453047&endTime=1561453347
  Future<List<MarketHistoryResponseModel>> getMarketHistory(
      {String startTime,
      String endTime,
      String asset,
      MarketDuration duration}) async {
    var response = await newDio.get(
        '/kline?interval=${marketDurationMap[duration]}&endTime=$endTime&limit=300');
    // var response = await dio.get(
    //     '/klines?assetName=$asset&interval=${marketDurationMap[duration]}&startTime=$startTime&endTime=$endTime&limit=300');
    var responseData = response.data as List;
    List<MarketHistoryResponseModel> model = responseData
        .map((data) {
          var model = MarketHistoryResponseModel();
          model.xts = data[0] * 1000000;
          model.px = data[4];
          return model;
        })
        .toList()
        .reversed
        .toList();
    return Future.value(model);
  }

  Future<List<KLineEntity>> getMarketHistoryCandle(
      {String startTime,
      String endTime,
      String asset,
      MarketDuration duration}) async {
    var response = await newDio.get(
        '/kline?interval=${marketDurationMap[duration]}&endTime=$endTime&limit=300');
    // var response = await dio.get(
    //     '/klines?assetName=$asset&interval=${marketDurationMap[duration]}&startTime=$startTime&endTime=$endTime&limit=300');
    var responseData = response.data as List;
    List<KLineEntity> model = responseData
        .map((value) {
          if (value[3] < value[4] / 3) {
            value[3] = value[4];
          }
          return KLineEntity.fromCustom(
              open: double.parse(value[1].toString()),
              high: double.parse(value[2].toString()),
              low: double.parse(value[3].toString()),
              close: double.parse(value[4].toString()),
              vol: 10000,
              id: value[0]);
        })
        .toList()
        .reversed
        .toList();
    return Future.value(model);
  }

  @override
  Future<DepositResponseModel> getDeposit({String name, String asset}) async {
    var response = await dio.get('/depositAddress',
        queryParameters: {"accountName": name, "asset": asset});
    return Future.value(DepositResponseModel.fromJson(response.data));
  }

  @override
  Future<PostOrderResponseModel> amendOrder(
      {AmendOrderRequestModel order, bool exNow}) async {
    var response = await newDio.post(exNow ? "/trade/close" : "/trade/amend",
        data: exNow ? order.toCloseJson() : order.toJson());
    return Future.value(PostOrderResponseModel.fromJson(response.data));
  }

  @override
  Future<PostOrderResponseModel> postOrder(
      {Map<String, dynamic> requestOrder}) async {
    var response = await newDio.post("/trade/order", data: requestOrder);
    return Future.value(PostOrderResponseModel.fromJson(response.data));
  }

  @override
  Future<PostOrderResponseModel> postWithdraw(
      {Map<String, dynamic> withdraw}) async {
    try {
      var response = await newDio.post("/trade/transfer", data: withdraw);

      return Future.value(PostOrderResponseModel.fromJson(response.data));
    } on DioError catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Future<PostOrderResponseModel> postTransfer(
      {Map<String, dynamic> transfer}) async {
    var response = await newDio.post("/trade/transfer", data: transfer);
    return Future.value(PostOrderResponseModel.fromJson(response.data));
  }

  @override
  Future<AccountResponseModel> getAccount({String name}) async {
    var response =
        await newDio.get("/account?accountName=$name&action=$action");
    return Future.value(response.data == null
        ? null
        : AccountResponseModel.fromJson(response.data));
  }

  @override
  Future<TestAccountResponseModel> getTestAccount(
      {bool bonusEvent, String accountName}) async {
    var response = await newDio.post("/trade/create_test_account");
    return Future.value(response.data == null
        ? null
        : TestAccountResponseModel.fromJson(response.data));
  }
}

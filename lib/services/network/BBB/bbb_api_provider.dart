import 'package:bbb_flutter/cache/shared_pref.dart';
import 'package:bbb_flutter/helper/common_utils.dart';
import 'package:bbb_flutter/models/request/amend_order_request_model.dart';
import 'package:bbb_flutter/models/request/post_order_request_model.dart';
import 'package:bbb_flutter/models/request/post_withdraw_request_model.dart';
import 'package:bbb_flutter/models/response/account_response_model.dart';
import 'package:bbb_flutter/models/response/fund_record_model.dart';
import 'package:bbb_flutter/models/response/market_history_response_model.dart';
import 'package:bbb_flutter/models/response/order_response_model.dart';
import 'package:bbb_flutter/models/response/positions_response_model.dart';
import 'package:bbb_flutter/models/response/post_order_response_model.dart';
import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
import 'package:bbb_flutter/models/response/test_account_response_model.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api.dart';
import 'package:bbb_flutter/setup.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:dio/dio.dart';
import 'package:bbb_flutter/models/response/deposit_response_model.dart';

class BBBAPIProvider extends BBBAPI {
  Dio dio = Dio();
  SharedPref _pref;

  BBBAPIProvider({SharedPref sharedPref}) {
    _pref = sharedPref;
    _dispatchNode();
    dio.options.connectTimeout = 15000;
    dio.options.receiveTimeout = 13000;
    setupProxy(dio);
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
  Future<PositionsResponseModel> getPositions({String name}) async {
    var response = await dio.get('/position?accountName=$name');
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
      params["startTime"] = startTime;
      params["endTime"] = endTime;
    }

    var response = await dio.get('/order', queryParameters: params);
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
    var response = await dio.get("/fund", queryParameters: {
      "accountName": name,
      "startTime": start.toIso8601String(),
      "endTime": end.toIso8601String()
    });
    var responseData = response.data as List;
    List<FundRecordModel> model = responseData.map((data) {
      return FundRecordModel.fromJson(data);
    }).toList();
    return model;
  }

  //assetName=BXBT&interval=1m&startTime=1561453047&endTime=1561453347
  Future<List<MarketHistoryResponseModel>> getMarketHistory(
      {String startTime,
      String endTime,
      String asset,
      MarketDuration duration}) async {
    var response = await dio.get(
        '/klines?assetName=$asset&interval=${marketDurationMap[duration]}&startTime=$startTime&endTime=$endTime&limit=300');
    var responseData = response.data as List;
    List<MarketHistoryResponseModel> model = responseData.map((data) {
      var model = MarketHistoryResponseModel();
      model.xts = data[0] * 1000000;
      model.px = data[4];
      return model;
    }).toList();
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
      {AmendOrderRequestModel order}) async {
    var response = await dio.post("/transaction", data: order.toJson());

    return Future.value(PostOrderResponseModel.fromJson(response.data));
  }

  @override
  Future<PostOrderResponseModel> postOrder(
      {PostOrderRequestModel order}) async {
    var response = await dio.post("/transaction", data: order.toJson());
    return Future.value(PostOrderResponseModel.fromJson(response.data));
  }

  @override
  Future<PostOrderResponseModel> postWithdraw(
      {PostWithdrawRequestModel withdraw}) async {
    var response =
        await dio.post("/transaction", data: withdraw.toWithdrawJson());
    return Future.value(PostOrderResponseModel.fromJson(response.data));
  }

  @override
  Future<PostOrderResponseModel> postTransfer(
      {PostWithdrawRequestModel transfer}) async {
    var response = await dio.post("/transaction",
        data: transfer.memo != null
            ? transfer.toWithdrawJson()
            : transfer.toJson());
    return Future.value(PostOrderResponseModel.fromJson(response.data));
  }

  @override
  Future<AccountResponseModel> getAccount({String name}) async {
    var response = await dio.get("/account?accountName=$name");
    return Future.value(response.data["result"] == null
        ? null
        : AccountResponseModel.fromJson(response.data["result"]));
  }

  @override
  Future<TestAccountResponseModel> getTestAccount(
      {bool bonusEvent, String accountName}) async {
    Dio singleDio = Dio();
    setupProxy(singleDio);
    if (_pref.getEnvType() == EnvType.Pro) {
      singleDio.options.baseUrl = NetworkConnection.PRO_TESTNET;
    } else if (_pref.getEnvType() == EnvType.Uat) {
      singleDio.options.baseUrl = NetworkConnection.UAT_TESTNET;
    }
    var params = Map<String, dynamic>();
    params["bonusEvent"] = bonusEvent;
    if (accountName != null) {
      params["cybexAccount"] = accountName;
    }
    var response = await singleDio.get("/testAccount", queryParameters: params);
    return Future.value(response.data["Status"] == "Failed"
        ? null
        : TestAccountResponseModel.fromJson(response.data));
  }
}

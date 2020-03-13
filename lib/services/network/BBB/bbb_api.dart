import 'package:bbb_flutter/models/request/amend_order_request_model.dart';
import 'package:bbb_flutter/models/response/account_response_model.dart';
import 'package:bbb_flutter/models/response/bbb_query_response/action_response.dart';
import 'package:bbb_flutter/models/response/bbb_query_response/config_response.dart';
import 'package:bbb_flutter/models/response/bbb_query_response/contract_response.dart';
import 'package:bbb_flutter/models/response/bbb_query_response/refData_response.dart';
import 'package:bbb_flutter/models/response/bbb_query_response/ticker_response.dart';
import 'package:bbb_flutter/models/response/fund_record_model.dart';
import 'package:bbb_flutter/models/response/limit_order_response_model.dart';
import 'package:bbb_flutter/models/response/market_history_response_model.dart';
import 'package:bbb_flutter/models/response/order_response_model.dart';
import 'package:bbb_flutter/models/response/positions_response_model.dart';
import 'package:bbb_flutter/models/response/post_order_response_model.dart';
import 'package:bbb_flutter/models/response/ranking_response_model.dart';
import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
import 'package:bbb_flutter/models/response/deposit_response_model.dart';
import 'package:bbb_flutter/models/response/test_account_response_model.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/widgets/k_line/entity/k_line_entity.dart';

abstract class BBBAPI {
  setTestNet({bool isTestNet});
  setEnvMode({EnvType envType});
  setAction({String action});
  setAsset({String asset});
  Future<RefContractResponseModel> getRefData({List<ContractStatus> status});
  Future<RefDataResponse> getRefDataNew({String injectAction});
  Future<ContractResponse> getContract({String active});
  Future<ActionResponse> getActions();
  Future<ConfigResponse> getConfig();
  Future<TickerResponse> getTicker({String injectAsset});
  Future<PositionsResponseModel> getPositions(
      {String name, String injectAction});
  Future<PositionsResponseModel> getPositionsTestAccount({String name});
  Future<List<OrderResponseModel>> getOrders(String name,
      {List<OrderStatus> status,
      String startTime,
      String endTime,
      String injectAsset});
  Future<List<LimitOrderResponse>> getLimitOrders(String name,
      {String startTime, String endTime, String active, String injectAsset});
  Future<AccountResponseModel> getAccount({String name});
  Future<List<MarketHistoryResponseModel>> getMarketHistory(
      {String startTime, String endTime, MarketDuration duration});
  Future<List<KLineEntity>> getMarketHistoryCandle(
      {String startTime, String endTime, MarketDuration duration});
  Future<DepositResponseModel> getDeposit({String name, String asset});

  Future<List<FundRecordModel>> getFundRecords(
      {String name, DateTime start, DateTime end});
  Future<TestAccountResponseModel> getTestAccount(
      {bool bonusEvent, String accountName});
  Future<List<RankingResponse>> getRankings({int indicator});

  ///post
  Future<PostOrderResponseModel> postOrder({Map<String, dynamic> requestOrder});
  Future<PostOrderResponseModel> postLimitOrder(
      {Map<String, dynamic> requestLimitOrder});
  Future<PostOrderResponseModel> postCancelLimitOrder(
      {Map<String, dynamic> requestCancelLimitOrder});
  Future<PostOrderResponseModel> amendOrder(
      {AmendOrderRequestModel order, bool exNow});
  Future<PostOrderResponseModel> postWithdraw({Map<String, dynamic> withdraw});
  Future<PostOrderResponseModel> postTransfer({Map<String, dynamic> transfer});
}

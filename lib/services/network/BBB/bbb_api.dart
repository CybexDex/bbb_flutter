import 'package:bbb_flutter/models/request/amend_order_request_model.dart';
import 'package:bbb_flutter/models/request/post_order_request_model.dart';
import 'package:bbb_flutter/models/request/post_withdraw_request_model.dart';
import 'package:bbb_flutter/models/response/account_response_model.dart';
import 'package:bbb_flutter/models/response/fund_record_model.dart';
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
  Future<RefContractResponseModel> getRefData({List<ContractStatus> status});
  Future<PositionsResponseModel> getPositions({String name});
  Future<PositionsResponseModel> getPositionsTestAccount({String name});
  Future<List<OrderResponseModel>> getOrders(String name,
      {List<OrderStatus> status, String startTime, String endTime});
  Future<AccountResponseModel> getAccount({String name});
  Future<List<MarketHistoryResponseModel>> getMarketHistory(
      {String startTime,
      String endTime,
      String asset,
      MarketDuration duration});
  Future<List<KLineEntity>> getMarketHistoryCandle(
      {String startTime,
      String endTime,
      String asset,
      MarketDuration duration});
  Future<DepositResponseModel> getDeposit({String name, String asset});

  Future<List<FundRecordModel>> getFundRecords(
      {String name, DateTime start, DateTime end});
  Future<TestAccountResponseModel> getTestAccount(
      {bool bonusEvent, String accountName});
  Future<List<RankingResponse>> getRankings({int indicator});

  ///post
  Future<PostOrderResponseModel> postOrder({PostOrderRequestModel order});
  Future<PostOrderResponseModel> amendOrder({AmendOrderRequestModel order});
  Future<PostOrderResponseModel> postWithdraw(
      {PostWithdrawRequestModel withdraw});
  Future<PostOrderResponseModel> postTransfer(
      {PostWithdrawRequestModel transfer});
}

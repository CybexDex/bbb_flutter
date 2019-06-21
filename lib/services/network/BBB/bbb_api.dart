import 'package:bbb_flutter/models/request/amend_order_request_model.dart';
import 'package:bbb_flutter/models/request/post_order_request_model.dart';
import 'package:bbb_flutter/models/response/account_response_model.dart';
import 'package:bbb_flutter/models/response/market_history_response_model.dart';
import 'package:bbb_flutter/models/response/order_response_model.dart';
import 'package:bbb_flutter/models/response/positions_response_model.dart';
import 'package:bbb_flutter/models/response/post_order_response_model.dart';
import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
import 'package:bbb_flutter/models/response/deposit_response_model.dart';

abstract class BBBAPI {
  Future<RefContractResponseModel> getRefData();
  Future<PositionsResponseModel> getPositions({String name});
  Future<List<OrderResponseModel>> getOrders({String name});
  Future<AccountResponseModel> getAccount({String name});
  Future<List<MarketHistoryResponseModel>> getMarketHistory(
      {String startTime, String endTime, String asset});
  Future<DepositResponseModel> getDeposit({String name, String asset});

  ///post
  Future<PostOrderResponseModel> postOrder({PostOrderRequestModel order});
  Future<PostOrderResponseModel> amendOrder({AmendOrderRequestModel order});
}

import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
import 'package:bbb_flutter/models/response/post_order_response_model.dart';
import 'package:bbb_flutter/models/response/market_history_response_model.dart';
import 'package:bbb_flutter/models/request/amend_order_request_model.dart';
import 'package:bbb_flutter/models/request/post_order_request_model.dart';

class ModelFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "RefContractResponseModel") {
      return RefContractResponseModel.fromJson(json) as T;
    } else if (T.toString() == "PostOrderResponseModel") {
      return PostOrderResponseModel.fromJson(json) as T;
    } else if (T.toString() == "MarketHistoryResponseModel") {
      return MarketHistoryResponseModel.fromJson(json) as T;
    } else if (T.toString() == "AmendOrderRequestModel") {
      return AmendOrderRequestModel.fromJson(json) as T;
    } else if (T.toString() == "PostOrderRequestModel") {
      return PostOrderRequestModel.fromJson(json) as T;
    } else {
      return null;
    }
  }
}
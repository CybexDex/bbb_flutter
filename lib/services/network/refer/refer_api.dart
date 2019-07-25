import 'package:bbb_flutter/models/request/post_ref_request_model.dart';
import 'package:bbb_flutter/models/response/query_ref_response_model.dart';
import 'package:bbb_flutter/models/response/register_ref_response_model.dart';

abstract class ReferApi {
  Future<QueryRefResponseModel> queryRef({String accountName});

  ///post
  Future<RegisterRefResponseModel> registerRef(
      {PostRefRequestModel postRefRequestModel});
}

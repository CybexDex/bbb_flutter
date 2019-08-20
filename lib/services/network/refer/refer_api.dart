import 'package:bbb_flutter/models/request/post_ref_request_model.dart';
import 'package:bbb_flutter/models/response/query_ref_response_model.dart';
import 'package:bbb_flutter/models/response/refer_top_list_response.dart';
import 'package:bbb_flutter/models/response/register_ref_response_model.dart';
import 'package:bbb_flutter/shared/types.dart';

abstract class ReferApi {
  setEnvMode({EnvType envType});
  Future<QueryRefResponseModel> queryRef({String accountName});
  Future<ReferTopListResponse> getTopList({String accountName});

  ///post
  Future<RegisterRefResponseModel> registerRef(
      {PostRefRequestModel postRefRequestModel});
}

import 'package:bbb_flutter/models/request/node_request_model.dart';
import 'package:bbb_flutter/models/response/node_response_model.dart';
import 'package:bbb_flutter/models/response/node_top_list_response_model.dart';
import 'package:bbb_flutter/shared/types.dart';

abstract class NodeApi {
  setEnvMode({EnvType envType});

  ///post
  Future<NodeResponose<int>> getTotalTransfer(
      {NodeRequestModel<String> nodeRequestModel});
  Future<NodeResponose<NodeTopListResponse>> getTopTransferByFromAssetHuman(
      {NodeRequestModel<String> nodeRequestModel});
}

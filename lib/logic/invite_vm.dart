import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/helper/utils.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/entity/available_assets.dart';
import 'package:bbb_flutter/models/request/node_request_model.dart';
import 'package:bbb_flutter/models/request/post_ref_request_model.dart';
import 'package:bbb_flutter/models/response/node_response_model.dart';
import 'package:bbb_flutter/models/response/node_top_list_response_model.dart';
import 'package:bbb_flutter/models/response/query_ref_response_model.dart';
import 'package:bbb_flutter/models/response/refer_top_list_response.dart';
import 'package:bbb_flutter/models/response/register_ref_response_model.dart';
import 'package:bbb_flutter/services/network/node/node_api.dart';
import 'package:bbb_flutter/services/network/refer/refer_api.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:cybex_flutter_plugin/cybex_flutter_plugin.dart';

class InviteViewModel extends BaseModel {
  ReferApi _api;
  NodeApi _nodeApi;
  UserManager _um;
  RefManager _ref;

  QueryRefResponseModel queryRefResponseModel;
  RegisterRefResponseModel registerRefResponseModel;
  List<NodeTopListResponse> referTopList = [];
  User referUserAmount;
  int referralNumber = 0;
  double referRewardAmount = 0;
  String referrer;
  List<ReferralList> referralList = [];

  InviteViewModel(
      {@required ReferApi api,
      @required NodeApi nodeApi,
      @required RefManager refm,
      @required UserManager um}) {
    _api = api;
    _um = um;
    _ref = refm;
    _nodeApi = nodeApi;
  }

  void getRefer() async {
    queryRefResponseModel = await _api.queryRef(accountName: _um.user.name);
    await getTotalTransfer();
    await getTotalTopList();
    getReferer();
    getReferrals();
    setBusy(false);
  }

  Future<RegisterRefResponseModel> postRefer({String referrer}) async {
    PostRefRequestModel requestModel = PostRefRequestModel();
    requestModel.account = _um.user.name;
    requestModel.action = ReferAction;
    requestModel.referrer = referrer;
    requestModel.expiration =
        DateTime.now().add(Duration(days: 1)).millisecondsSinceEpoch ~/ 1000;

    List<int> result = [];
    List<int> a = utf8.encode(requestModel.account);
    result.add(a.length);
    result.addAll(a);
    List<int> action = utf8.encode(requestModel.action);
    result.add(action.length);
    result.addAll(action);
    List<int> b = utf8.encode(requestModel.referrer);
    result.add(b.length);
    result.addAll(b);
    for (int i = 0; i < 8; i++) {
      result.add(requestModel.expiration >> (8 * i) & 0xff);
    }
    String c = formatBytesAsHexString(Uint8List.fromList(result));
    String sig = await CybexFlutterPlugin.signStreamOperation(c);
    String finalSig = sig.replaceAll("\"", "");
    requestModel.signature = finalSig;
    RegisterRefResponseModel registerRefResponse =
        await _api.registerRef(postRefRequestModel: requestModel);
    return registerRefResponse;
  }

  void getReferer() {
    List<Referrers> referrers =
        queryRefResponseModel?.result?.referrers?.where((element) {
      return element.action == ReferAction;
    })?.toList();
    if (referrers.isNotEmpty) {
      referrer = referrers.first.referrer;
    }
  }

  void getReferrals() {
    List<Referrals> referrals =
        queryRefResponseModel?.result?.referrals?.where((element) {
      return element.action == ReferAction;
    })?.toList();
    if (referrals.isNotEmpty) {
      referralNumber = referrals.first.referrals.length;
      referralList = referrals.first.referrals;
    }
  }

  // Future<List<Top3>> getTopList() async {
  //   ReferTopListResponse referTopListResponse =
  //       await _api.getTopList(accountName: _um.user.name);
  //   referTopList = referTopListResponse?.top3?.map((value) {
  //     value.amount = value.amount.floor() / pow(10, 6);
  //     return value;
  //   })?.toList();
  //   referUserAmount = referTopListResponse?.user;
  //   return referTopList;
  // }

  Future getTotalTransfer() async {
    AvailableAsset rebateAsset = AvailableAsset(
        assetId: _ref.refDataControllerNew.value.bbbAssetId,
        precision: _ref.refDataControllerNew.value.bbbAssetPrecision);
    List<String> params = [
      AccountID.REFER_REBATE_ACCOUNT_ID,
      _um.user.account.id,
      rebateAsset.assetId
    ];
    NodeRequestModel<String> nodeRequestModel =
        NodeRequestModel(params: params, method: MethodName.TOTAL_TRANSFER);
    NodeResponose<int> totalTranfer =
        await _nodeApi.getTotalTransfer(nodeRequestModel: nodeRequestModel);
    referRewardAmount = totalTranfer?.result != null
        ? (totalTranfer.result[1] / pow(10, rebateAsset?.precision))
        : 0;
  }

  Future getTotalTopList() async {
    List<String> params = [AccountName.REFER_REBATE_ACCOUNT, AssetName.NXUSDT];
    NodeRequestModel<String> nodeRequestModel =
        NodeRequestModel(params: params, method: MethodName.TOP_LIST);
    NodeResponose<NodeTopListResponse> toplist = await _nodeApi
        .getTopTransferByFromAssetHuman(nodeRequestModel: nodeRequestModel);
    referTopList = toplist.result ?? [];
  }
}

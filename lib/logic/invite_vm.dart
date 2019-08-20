import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/helper/utils.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/request/post_ref_request_model.dart';
import 'package:bbb_flutter/models/response/query_ref_response_model.dart';
import 'package:bbb_flutter/models/response/refer_top_list_response.dart';
import 'package:bbb_flutter/models/response/register_ref_response_model.dart';
import 'package:bbb_flutter/services/network/refer/refer_api.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:cybex_flutter_plugin/cybex_flutter_plugin.dart';

class InviteViewModel extends BaseModel {
  ReferApi _api;
  UserManager _um;
  QueryRefResponseModel queryRefResponseModel;
  RegisterRefResponseModel registerRefResponseModel;
  List<Top3> referTopList = [];
  User referUserAmount;
  int referralNumber = 0;
  String referrer;
  List<ReferralList> referralList = [];

  InviteViewModel({@required ReferApi api, @required UserManager um}) {
    _api = api;
    _um = um;
  }

  void getRefer() async {
    queryRefResponseModel = await _api.queryRef(accountName: _um.user.name);
    await getTopList();
    getReferer();
    getReferrals();
    setBusy(false);
  }

  Future<RegisterRefResponseModel> postRefer({String referrer}) async {
    PostRefRequestModel requestModel = PostRefRequestModel();
    requestModel.account = _um.user.name;
    requestModel.action = "bbbtest";
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
      return element.action == "bbbtest";
    })?.toList();
    if (referrers.isNotEmpty) {
      referrer = referrers.first.referrer;
    }
  }

  void getReferrals() {
    List<Referrals> referrals =
        queryRefResponseModel?.result?.referrals?.where((element) {
      return element.action == "bbbtest";
    })?.toList();
    if (referrals.isNotEmpty) {
      referralNumber = referrals.first.referrals.length;
      referralList = referrals.first.referrals;
    }
  }

  Future<List<Top3>> getTopList() async {
    ReferTopListResponse referTopListResponse =
        await _api.getTopList(accountName: _um.user.name);
    referTopList = referTopListResponse?.top3?.map((value) {
      value.amount = value.amount.floor() / pow(10, 6);
      return value;
    })?.toList();
    referUserAmount = referTopListResponse?.user;
    return referTopList;
  }
}

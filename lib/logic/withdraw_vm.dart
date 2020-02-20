import 'dart:async';
import 'dart:math';

import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/cache/shared_pref.dart';
import 'package:bbb_flutter/helper/asset_utils.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/entity/account_keys_entity.dart';
import 'package:bbb_flutter/models/entity/available_assets.dart';
import 'package:bbb_flutter/models/form/order_form_model.dart';
import 'package:bbb_flutter/models/form/withdraw_form_model.dart';
import 'package:bbb_flutter/models/request/post_withdraw_request_model.dart';
import 'package:bbb_flutter/models/response/account_response_model.dart';
import 'package:bbb_flutter/models/response/bbb_query_response/refData_response.dart';
import 'package:bbb_flutter/models/response/gateway_asset_response_model.dart';
import 'package:bbb_flutter/models/response/gateway_verifyaddress_response_model.dart';
import 'package:bbb_flutter/models/response/positions_response_model.dart';
import 'package:bbb_flutter/models/response/post_order_response_model.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api.dart';
import 'package:bbb_flutter/services/network/gateway/getway_api.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:cybex_flutter_plugin/commision.dart';
import 'package:cybex_flutter_plugin/cybex_flutter_plugin.dart';
import 'package:cybex_flutter_plugin/order.dart';

class WithdrawViewModel extends BaseModel {
  WithdrawViewModel(
      {@required BBBAPI api,
      @required RefManager refm,
      @required UserManager um,
      @required GatewayApi gatewayApi,
      this.withdrawForm}) {
    _api = api;
    _refm = refm;
    _um = um;
    _gatewayApi = gatewayApi;
  }

  Commission commission;
  GatewayAssetResponseModel gatewayAssetResponseModel;
  bool isHide = true;
  VerifyAddressResponseModel verifyAddressResponseModel;
  WithdrawForm withdrawForm;
  PostWithdrawRequestModel withdrawRequestModel;
  AccountResponseModel adminAccount;
  AccountResponseModel gatewayAccount;

  BBBAPI _api;
  GatewayApi _gatewayApi;
  RefManager _refm;
  UserManager _um;

  initForm() {
    withdrawForm = WithdrawForm(
        totalAmount: Asset(amount: 0),
        balance: Position(quantity: 0),
        address: "");
    gatewayAssetResponseModel = GatewayAssetResponseModel(
        minWithdraw: 0, withdrawSwitch: false, withdrawFee: "0.0");
    getAsset();
    getCurrentBalance();
    getMemoKey();
  }

  void fetchBalances() {
    withdrawForm.balance =
        _um.fetchPositionFrom(_refm.refDataControllerNew.value.bbbAssetId) ??
            Position(quantity: 0);
    withdrawForm.cybBalance =
        _um.fetchPositionFrom(AssetId.CYB) ?? Position(quantity: 0);
  }

  void getCurrentBalance() async {
    await _um.fetchBalances(name: _um.user.name);
    fetchBalances();
    setButtonAvailable();
    setBusy(false);
  }

  void getMemoKey() async {
    adminAccount = await _api.getAccount(
        name: _refm.refDataControllerNew.value.adminAccountId);
    gatewayAccount = await _api.getAccount(
        name: _refm.refDataControllerNew.value.gatewayAccountId);
  }

  void getAsset() async {
    gatewayAssetResponseModel =
        await _gatewayApi.getAsset(asset: AssetName.USDTERC20);
    setButtonAvailable();
    setBusy(false);
  }

  void verifyAddress({String address}) async {
    try {
      verifyAddressResponseModel = await _gatewayApi.verifyAddress(
          asset: AssetName.USDTERC20, address: address);
      setButtonAvailable();
    } catch (e) {
      verifyAddressResponseModel = VerifyAddressResponseModel();
      verifyAddressResponseModel.valid = false;
      setButtonAvailable();
    }
    setBusy(false);
  }

  void setTotalAmount(Asset amount) {
    withdrawForm.totalAmount = amount;
    setButtonAvailable();
    setBusy(false);
  }

  void setButtonAvailable() {
    if (withdrawForm.totalAmount.amount <= withdrawForm.balance.quantity &&
        withdrawForm.totalAmount.amount >=
            gatewayAssetResponseModel.minWithdraw &&
        gatewayAssetResponseModel.withdrawSwitch &&
        (verifyAddressResponseModel == null ||
            verifyAddressResponseModel.valid)) {
      isHide = true;
    } else {
      isHide = false;
    }
  }

  Future<PostOrderResponseModel> postWithdraw() async {
    final refData = _refm.refDataControllerNew.value;
    commission = getCommission(refData);

    Map<String, dynamic> transaction =
        await CybexFlutterPlugin.transferOperation(commission);
    Map<String, dynamic> request = {"transaction": transaction};
    printWrapped(transaction.toString());

    try {
      PostOrderResponseModel res = await _api.postWithdraw(withdraw: request);
      print(res);
      return Future.value(res);
    } catch (e) {
      return Future.error(e);
    }
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

//  void saveOrder() {
//    ticker = _mtm.lastTicker.value;
//    saveContract =
//        orderForm.isUp ? _refm.currentUpContract : _refm.currentDownContract;
//
//    final refData = _refm.lastData;
//
//    order = PostOrderRequestModel();
//    commission = getCommission(refData, contract);
//  }

  Commission getCommission(RefDataResponse refData) {
    AccountKeysEntity keys = locator.get<SharedPref>().getAccountKeys();
    WithdrawForm form = withdrawForm;
    AvailableAsset quoteAsset = AvailableAsset(
        assetId: refData.bbbAssetId, precision: refData.bbbAssetPrecision);
    int expir = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;

    Commission comm = Commission();
    comm.chainid = refData.chainId;
    comm.refBlockNum = refData.blockNum;
    comm.refBlockId = refData.blockId;

    comm.txExpiration = expir + 5 * 60;
    comm.fee = AssetDef.cybTransfer;
    comm.from = suffixId(_um.user.account.id);
    comm.to = suffixId(refData.adminAccountId);
    comm.amount = AmountToSell(
        assetId: suffixId(quoteAsset.assetId),
        amount:
            (form.totalAmount.amount * pow(10, quoteAsset.precision)).toInt());
    comm.isTwo = true;
    comm.fromMemoKey = keys.activeKey.publicKey;
    comm.toMemoKey = adminAccount.options.memoKey;
    comm.gatewayMemoKey = gatewayAccount.options.memoKey;
    comm.gatewayAssetId = suffixId(refData.gatewayAccountId);
    comm.memo = withdrawForm.address;
    comm.assetId = suffixId(refData.bbbAssetId);
    return comm;
  }
}

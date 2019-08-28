import 'dart:async';
import 'dart:math';

import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/cache/shared_pref.dart';
import 'package:bbb_flutter/helper/asset_utils.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/form/order_form_model.dart';
import 'package:bbb_flutter/models/form/withdraw_form_model.dart';
import 'package:bbb_flutter/models/request/post_withdraw_request_model.dart';
import 'package:bbb_flutter/models/response/gateway_asset_response_model.dart';
import 'package:bbb_flutter/models/response/gateway_verifyaddress_response_model.dart';
import 'package:bbb_flutter/models/response/positions_response_model.dart';
import 'package:bbb_flutter/models/response/post_order_response_model.dart';
import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api.dart';
import 'package:bbb_flutter/services/network/gateway/getway_api.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:cybex_flutter_plugin/commision.dart';
import 'package:cybex_flutter_plugin/cybex_flutter_plugin.dart';
import 'package:cybex_flutter_plugin/order.dart';
import 'package:logger/logger.dart';

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

  BBBAPI _api;
  GatewayApi _gatewayApi;
  RefManager _refm;
  UserManager _um;

  initForm() {
    withdrawForm = WithdrawForm(
        totalAmount: Asset(amount: 0, symbol: "USDT"),
        balance: Position(quantity: 0),
        address: "");
    gatewayAssetResponseModel = GatewayAssetResponseModel(
        minWithdraw: 0, withdrawSwitch: false, withdrawFee: "0.0");
    getAsset();
    getCurrentBalance();
  }

  void fetchBalances() {
    withdrawForm.balance =
        _um.fetchPositionFrom(AssetName.NXUSDT) ?? Position(quantity: 0);
    withdrawForm.cybBalance = _um.fetchPositionFrom(AssetName.CYB) ??
        Position(assetName: AssetName.CYB, quantity: 0);
  }

  void getCurrentBalance() async {
    await _um.fetchBalances(name: _um.user.name);
    fetchBalances();
    setButtonAvailable();
    setBusy(false);
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
    final refData = _refm.lastData;

    var withdraw = PostWithdrawRequestModel();
    commission = getCommission(refData);

    withdraw.transfer = commission;

    withdraw.transfer = await CybexFlutterPlugin.transferOperation(commission);
    withdraw.transactionType = "NxWithdraw";
    withdraw.memo = withdrawForm.address;

    locator.get<Logger>().i(withdraw.toRawJson());

    PostOrderResponseModel res = await _api.postWithdraw(withdraw: withdraw);
    locator.get<Logger>().w(res.toRawJson());

    return Future.value(res);
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

  Commission getCommission(RefContractResponseModel refData) {
    WithdrawForm form = withdrawForm;
    AvailableAsset quoteAsset = refData.availableAssets
        .where((asset) {
          return asset.assetName == AssetName.NXUSDT;
        })
        .toList()
        .first;
    int expir = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;

    Commission comm = Commission();
    comm.chainid = refData.chainId;
    comm.refBlockNum = refData.refBlockNum;
    comm.refBlockPrefix = refData.refBlockPrefix;
    comm.refBlockId = refData.refBlockId;

    comm.txExpiration = expir + 5 * 60;
    comm.fee = AssetDef.CYB_TRANSFER;
    comm.from = suffixId(locator.get<SharedPref>().getTestNet()
        ? _um.user.testAccountResponseModel.accountId
        : _um.user.account.id);
    comm.to = suffixId(refData.accountKeysEntityOperator.accountId);
    comm.amount = AmountToSell(
        assetId: suffixId(quoteAsset.assetId),
        amount:
            (form.totalAmount.amount * pow(10, quoteAsset.precision)).toInt());

    return comm;
  }
}

import 'dart:async';
import 'dart:math';

import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/helper/asset_utils.dart';
import 'package:bbb_flutter/helper/order_calculate_helper.dart';
import 'package:bbb_flutter/manager/market_manager.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/form/order_form_model.dart';
import 'package:bbb_flutter/models/form/withdraw_form_model.dart';
import 'package:bbb_flutter/models/request/post_order_request_model.dart';
import 'package:bbb_flutter/models/request/post_withdraw_request_model.dart';
import 'package:bbb_flutter/models/response/post_order_response_model.dart';
import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api_provider.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:cybex_flutter_plugin/commision.dart';
import 'package:cybex_flutter_plugin/cybex_flutter_plugin.dart';
import 'package:cybex_flutter_plugin/order.dart';
import 'package:logger/logger.dart';

class WithdrawViewModel extends BaseModel {
  WithdrawForm withdrawForm;
  PostWithdrawRequestModel withdrawRequestModel;
  Commission commission;

  BBBAPIProvider _api;
  RefManager _refm;
  UserManager _um;

  WithdrawViewModel(
      {@required BBBAPIProvider api,
      @required RefManager refm,
      @required UserManager um,
      this.withdrawForm}) {
    _api = api;
    _refm = refm;
    _um = um;
  }

  initForm() {
    withdrawForm = WithdrawForm(
        totalAmount: Asset(amount: 0, symbol: "USDT"),
        balance: _um.fetchPositionFrom(AssetName.NXUSDT),
        address: "");

    getCurrentBalance();
  }

  void fetchBalances() {
    withdrawForm.balance = _um.fetchPositionFrom(AssetName.NXUSDT);
  }

  void getCurrentBalance() async {
    await _um.fetchBalances(name: _um.user.name);
    fetchBalances();
    setBusy(false);
  }

  void setTotalAmount(Asset amount) {
    withdrawForm.totalAmount = amount;
    setBusy(false);
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
    AvailableAsset quoteAsset =
        AvailableAsset(assetId: "1.3.723", precision: 6, assetName: "NXC.USDT");
    int expir = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;

    Commission comm = Commission();
    comm.chainid = refData.chainId;
    comm.refBlockNum = refData.refBlockNum;
    comm.refBlockPrefix = refData.refBlockPrefix;
    comm.refBlockId = refData.refBlockId;

    comm.txExpiration = expir + 5 * 60;
    comm.fee = AssetDef.CYB_TRANSFER;
    comm.from = suffixId(_um.user.account.id);
    comm.to = suffixId(refData.accountKeysEntityOperator.accountId);
    comm.amount = AmountToSell(
        assetId: suffixId(quoteAsset.assetId),
        amount:
            (form.totalAmount.amount * pow(10, quoteAsset.precision)).toInt());

    return comm;
  }
}

import 'dart:async';
import 'dart:math';

import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/cache/shared_pref.dart';
import 'package:bbb_flutter/helper/asset_utils.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/form/order_form_model.dart';
import 'package:bbb_flutter/models/form/transfer_form_model.dart';
import 'package:bbb_flutter/models/request/post_withdraw_request_model.dart';
import 'package:bbb_flutter/models/response/positions_response_model.dart';
import 'package:bbb_flutter/models/response/post_order_response_model.dart';
import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:cybex_flutter_plugin/commision.dart';
import 'package:cybex_flutter_plugin/cybex_flutter_plugin.dart';
import 'package:cybex_flutter_plugin/order.dart';
import 'package:logger/logger.dart';

class TransferViewModel extends BaseModel {
  TransferForm transferForm;
  PostWithdrawRequestModel withdrawRequestModel;
  Commission commission;
  bool isButtonAvailable = false;

  BBBAPI _api;
  RefManager _refm;
  UserManager _um;

  TransferViewModel(
      {@required BBBAPI api,
      @required RefManager refm,
      @required UserManager um,
      this.transferForm}) {
    _api = api;
    _refm = refm;
    _um = um;
  }

  initForm() {
    transferForm = TransferForm(
            fromBBBToCybex: true,
            totalAmount: Asset(amount: null, symbol: "USDT"),
            balance: _um.fetchPositionFrom(AssetName.NXUSDT) ??
                Position(assetName: AssetName.NXUSDT, quantity: 0),
            cybBalance: _um.fetchPositionFrom(AssetName.CYB)) ??
        Position(assetName: AssetName.CYB, quantity: 0);
    getCurrentBalance();
  }

  void switchAccountSide() {
    transferForm.fromBBBToCybex = !transferForm.fromBBBToCybex;
    fetchBalances();
    setTotalAmount(value: transferForm.totalAmount.amount);
    setBusy(false);
  }

  void fetchBalances() {
    transferForm.balance = transferForm.fromBBBToCybex
        ? _um.fetchPositionFrom(AssetName.NXUSDT)
        : _um.fetchPositionFrom(AssetName.USDT);
    transferForm.totalAmount.symbol = transferForm?.balance?.assetName;
  }

  void getCurrentBalance() async {
    await _um.fetchBalances(name: _um.user.name);
    fetchBalances();
    setTotalAmount(value: transferForm.totalAmount.amount);
    setBusy(false);
  }

  void setTotalAmount({double value}) {
    transferForm.totalAmount.amount = value;
    if (value == null ||
        transferForm.balance == null ||
        value > transferForm.balance.quantity ||
        value <= 0) {
      isButtonAvailable = false;
    } else {
      isButtonAvailable = true;
    }
    setBusy(false);
  }

  Future<PostOrderResponseModel> postTransfer() async {
    final refData = _refm.lastData;

    var withdraw = PostWithdrawRequestModel();
    commission = getCommission(refData);

    withdraw.transfer = commission;

    withdraw.transfer = await CybexFlutterPlugin.transferOperation(commission);
    withdraw.transactionType =
        transferForm.fromBBBToCybex ? "NxCybexWithdraw" : "NxCybexDeposit";
    withdraw.memo = transferForm.fromBBBToCybex ? "" : null;

    locator.get<Logger>().i(withdraw.toRawJson());

    PostOrderResponseModel res = await _api.postTransfer(transfer: withdraw);
    locator.get<Logger>().w(res.toRawJson());

    return Future.value(res);
  }

  Commission getCommission(RefContractResponseModel refData) {
    TransferForm form = transferForm;
    AvailableAsset quoteAsset = transferForm.fromBBBToCybex
        ? refData.availableAssets
            .where((asset) {
              return asset.assetName == AssetName.NXUSDT;
            })
            .toList()
            .first
        : AvailableAsset(assetId: "1.3.27", precision: 6, assetName: "USDT");
    int expir = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;

    Commission comm = Commission();
    comm.chainid = refData.chainId;
    comm.refBlockNum = refData.refBlockNum;
    comm.refBlockPrefix = refData.refBlockPrefix;
    comm.refBlockId = refData.refBlockId;

    comm.txExpiration = expir + 5 * 60;
    comm.fee = AssetDef.cybTransfer;
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

import 'dart:async';
import 'dart:math';

import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/helper/asset_utils.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/entity/available_assets.dart';
import 'package:bbb_flutter/models/form/order_form_model.dart';
import 'package:bbb_flutter/models/form/transfer_form_model.dart';
import 'package:bbb_flutter/models/request/post_withdraw_request_model.dart';
import 'package:bbb_flutter/models/response/bbb_query_response/refData_response.dart';
import 'package:bbb_flutter/models/response/positions_response_model.dart';
import 'package:bbb_flutter/models/response/post_order_response_model.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:cybex_flutter_plugin/commision.dart';
import 'package:cybex_flutter_plugin/cybex_flutter_plugin.dart';
import 'package:cybex_flutter_plugin/order.dart';

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
            totalAmount: Asset(amount: null),
            balance: _um.fetchPositionFrom(
                    _refm.refDataControllerNew.value.bbbAssetId) ??
                Position(
                    assetId: _refm.refDataControllerNew.value.bbbAssetId,
                    quantity: 0),
            cybBalance: _um.fetchPositionFrom(
              AssetId.CYB,
            )) ??
        Position(assetId: AssetId.CYB, quantity: 0);
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
        ? _um.fetchPositionFrom(_refm.refDataControllerNew.value.bbbAssetId)
        : _um.fetchPositionFrom(_refm.refDataControllerNew.value.cybexAssetId);
    transferForm.totalAmount.assetId = transferForm?.balance?.assetId;
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
    final refData = _refm.refDataControllerNew.value;

    var withdraw = PostWithdrawRequestModel();
    commission = getCommission(refData);

    withdraw.transfer = commission;
    Map<String, dynamic> transaction =
        await CybexFlutterPlugin.transferOperation(commission);
    print(transaction);

    Map<String, dynamic> request = {"transaction": transaction};
    try {
      PostOrderResponseModel res = await _api.postTransfer(transfer: request);
      print(res);
      return Future.value(res);
    } catch (e) {
      return Future.error(e);
    }
  }

  Commission getCommission(RefDataResponse refData) {
    TransferForm form = transferForm;
    AvailableAsset quoteAsset = transferForm.fromBBBToCybex
        ? AvailableAsset(
            assetId: refData.bbbAssetId, precision: refData.bbbAssetPrecision)
        : AvailableAsset(assetId: "1.3.27", precision: 6, assetName: "USDT");
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
    comm.assetId = suffixId(refData.bbbAssetId);

    print(comm.toRawJson());

    return comm;
  }
}

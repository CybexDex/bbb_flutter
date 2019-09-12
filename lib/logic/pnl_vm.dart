import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/cache/shared_pref.dart';
import 'package:bbb_flutter/helper/asset_utils.dart';
import 'package:bbb_flutter/helper/order_calculate_helper.dart';
import 'package:bbb_flutter/manager/market_manager.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/request/amend_order_request_model.dart';
import 'package:bbb_flutter/models/response/order_response_model.dart';
import 'package:bbb_flutter/models/response/post_order_response_model.dart';
import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api.dart';
import 'package:cybex_flutter_plugin/cybex_flutter_plugin.dart';
import 'package:logger/logger.dart';

import '../setup.dart';

class PnlViewModel extends BaseModel {
  double cutLoss;
  double takeProfit;
  double cutLossPx;
  double takeProfitPx;
  double invest;
  double pnlPercent;
  bool shouldShowErrorMessage = false;
  bool isTakeProfitInputCorrect = true;
  bool isCutLossInputCorrect = true;
  BBBAPI _api;
  UserManager _um;
  MarketManager _mtm;
  RefManager _refm;

  PnlViewModel(
      {BBBAPI api, UserManager um, MarketManager mtm, RefManager refm}) {
    _api = api;
    _um = um;
    _mtm = mtm;
    _refm = refm;
  }

  Contract currentContract(OrderResponseModel order) {
    return _refm.getContractFromId(order.contractId);
  }

  Future<PostOrderResponseModel> amend(
      OrderResponseModel order, bool execNow) async {
    if (_um.user.testAccountResponseModel != null) {
      CybexFlutterPlugin.setDefaultPrivKey(
          _um.user.testAccountResponseModel.privateKey);
    }
    final ticker = _mtm.lastTicker.value;
    int epochTime = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
    final contract = currentContract(order);

    final model = AmendOrderRequestModel();
    model.transactionType = "NxAmend";
    model.cutLossPx = execNow
        ? order.cutLossPx.toStringAsFixed(4)
        : (cutLoss == null
            ? contract.strikeLevel.toStringAsFixed(4)
            : OrderCalculate.cutLossPx(cutLoss, order.underlyingSpotPx,
                    contract.strikeLevel, contract.conversionRate > 0)
                .toStringAsFixed(4));
    model.takeProfitPx = execNow
        ? order.takeProfitPx.toStringAsFixed(4)
        : (takeProfit == null
            ? "0"
            : OrderCalculate.takeProfitPx(takeProfit, order.underlyingSpotPx,
                    contract.strikeLevel, contract.conversionRate > 0)
                .toStringAsFixed(4));
    model.seller = suffixId(locator.get<SharedPref>().getTestNet()
        ? _um.user.testAccountResponseModel.accountId
        : _um.user.account.id);
    model.refBuyOrderTxId = order.buyOrderTxId;
    model.execNowPx = ticker.value.toString();
    model.expiration = execNow
        ? epochTime
        : (_um.user.testAccountResponseModel != null &&
                _um.user.testAccountResponseModel.accountType >= 1
            ? _um.user.testAccountResponseModel.expiration
            : 0);
    model.amendCreationTime = epochTime;

    final sig =
        await CybexFlutterPlugin.signMessageOperation(model.toStreamString());

    model.signature = sig.replaceAll("\"", "");

    print(model.toRawJson());
    try {
      PostOrderResponseModel res = await _api.amendOrder(order: model);
      locator.get<Logger>().w(res.toRawJson());
      return res;
    } catch (error) {
      return Future.error(error);
    }
  }

  void increaseTakeProfit({OrderResponseModel order}) {
    if (takeProfit == null) {
      takeProfit = 50;
    } else {
      takeProfit += 1;
    }
    final contract = currentContract(order);
    takeProfitPx = OrderCalculate.takeProfitPx(
        takeProfit,
        order.underlyingSpotPx,
        contract.strikeLevel,
        contract.conversionRate > 0);
    setBusy(false);
  }

  void decreaseTakeProfit({OrderResponseModel order}) {
    if (takeProfit == null) {
      takeProfit = 50;
    } else {
      if (takeProfit.round() > 0) {
        takeProfit -= 1;
      }
    }
    final contract = currentContract(order);
    takeProfitPx = OrderCalculate.takeProfitPx(
        takeProfit,
        order.underlyingSpotPx,
        contract.strikeLevel,
        contract.conversionRate > 0);
    setBusy(false);
  }

  void changeTakeProfit({double profit, OrderResponseModel order}) {
    this.takeProfit = profit;
    final contract = currentContract(order);
    takeProfitPx = profit == null
        ? 0
        : OrderCalculate.takeProfitPx(takeProfit, order.underlyingSpotPx,
            contract.strikeLevel, contract.conversionRate > 0);
    setBusy(false);
  }

  void increaseCutLoss({OrderResponseModel order}) {
    if (cutLoss == null) {
      cutLoss = 50;
    } else {
      if (cutLoss.round() < 100) {
        cutLoss += 1;
      }
    }
    final contract = currentContract(order);
    cutLossPx = OrderCalculate.cutLossPx(cutLoss, order.underlyingSpotPx,
        contract.strikeLevel, contract.conversionRate > 0);
    setBusy(false);
  }

  void decreaseCutLoss({OrderResponseModel order}) {
    if (cutLoss == null) {
      cutLoss = 50;
    } else {
      if (cutLoss.round() > 0) {
        cutLoss -= 1;
      }
    }
    final contract = currentContract(order);
    cutLossPx = OrderCalculate.cutLossPx(cutLoss, order.underlyingSpotPx,
        contract.strikeLevel, contract.conversionRate > 0);
    setBusy(false);
  }

  void changeCutLoss({double cutLoss, OrderResponseModel order}) {
    this.cutLoss = cutLoss;
    final contract = currentContract(order);
    cutLoss == null
        ? contract.strikeLevel.toStringAsFixed(4)
        : OrderCalculate.cutLossPx(cutLoss, order.underlyingSpotPx,
            contract.strikeLevel, contract.conversionRate > 0);
    setBusy(false);
  }

  void setTakeProfitInputCorrectness(bool value) {
    isTakeProfitInputCorrect = value;
    setBusy(false);
  }

  void setCutLossInputCorectness(bool value) {
    isCutLossInputCorrect = value;
    setBusy(false);
  }

  Future<bool> checkPassword({String name, String password}) async {
    try {
      await _um.unlockWith(name: name, password: password);
      shouldShowErrorMessage = false;
      setBusy(false);
      return true;
    } catch (error) {
      shouldShowErrorMessage = true;
      setBusy(false);
      return false;
    }
  }
}

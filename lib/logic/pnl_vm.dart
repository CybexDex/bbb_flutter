import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/helper/order_calculate_helper.dart';
import 'package:bbb_flutter/helper/utils.dart';
import 'package:bbb_flutter/manager/market_manager.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/request/amend_order_request_model.dart';
import 'package:bbb_flutter/models/response/order_response_model.dart';
import 'package:bbb_flutter/models/response/post_order_response_model.dart';
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
  bool isCutLossCorrect = true;
  bool isObscure = true;
  BBBAPI _api;
  UserManager _um;

  PnlViewModel({BBBAPI api, UserManager um, MarketManager mtm, RefManager refm}) {
    _api = api;
    _um = um;
  }

  // Contract currentContract(OrderResponseModel order) {
  //   return _refm.getContractFromId(order.contractId);
  // }

  Future<PostOrderResponseModel> amend(
      OrderResponseModel order, bool execNow, bool amendByPrice) async {
    if (_um.user.testAccountResponseModel != null) {
      CybexFlutterPlugin.setDefaultPrivKey(_um.user.testAccountResponseModel.privkey);
    } else if (_um.user.keys == null) {
      CybexFlutterPlugin.setDefaultPrivKey(_um.user.privateKey);
    }
    int expir = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;

    final model = AmendOrderRequestModel(data: Data());
    model.data.action = order.action;
    model.data.user = _um.user.testAccountResponseModel != null
        ? _um.user.testAccountResponseModel.name
        : _um.user.account.name;
    model.data.orderId = order.buyOrderTxId;
    model.data.timeout = expir + 5 * 60;
    if (!execNow) {
      if (!amendByPrice) {
        model.data.cutlossPrice = cutLoss == null
            ? order.strikePx.toStringAsFixed(4)
            : OrderCalculate.cutLossPx(
                    cutLoss, order.boughtPx, order.strikePx, order.contractId.contains("N"))
                .toStringAsFixed(4);
        model.data.takeProfitPrice = takeProfit == null
            ? "0"
            : OrderCalculate.takeProfitPx(
                    takeProfit, order.boughtPx, order.strikePx, order.contractId.contains("N"))
                .toStringAsFixed(4);
      } else {
        model.data.cutlossPrice = cutLossPx.toStringAsFixed(4);
        model.data.takeProfitPrice = takeProfitPx.toStringAsFixed(4);
      }
    }

    var data = execNow ? model.data.toCloseJson() : model.data.toJson();
    String sig = await CybexFlutterPlugin.signMessageOperation(
        getQueryStringFromJson(data, data.keys.toList()..sort()));
    model.signature = sig.contains('\"') ? sig.substring(1, sig.length - 1) : sig;
    try {
      PostOrderResponseModel res = await _api.amendOrder(order: model, exNow: execNow);
      locator.get<Logger>().w(res);
      return res;
    } catch (error) {
      print(error);
      return Future.error(error);
    }
  }

  void increaseTakeProfit({OrderResponseModel order}) {
    if (takeProfit == null) {
      takeProfit = 1;
    } else {
      takeProfit += 1;
    }
    takeProfitPx = OrderCalculate.takeProfitPx(
        takeProfit, order.boughtPx, order.strikePx, order.contractId.contains("N"));
    setBusy(false);
  }

  void decreaseTakeProfit({OrderResponseModel order}) {
    if (takeProfit.round() > 0) {
      takeProfit -= 1;
    }
    takeProfitPx = takeProfit == null
        ? 0
        : OrderCalculate.takeProfitPx(
            takeProfit, order.boughtPx, order.strikePx, order.contractId.contains("N"));
    setBusy(false);
  }

  void changeTakeProfit({double profit, OrderResponseModel order}) {
    this.takeProfit = profit;
    takeProfitPx = profit == null
        ? 0
        : OrderCalculate.takeProfitPx(
            takeProfit, order.boughtPx, order.strikePx, order.contractId.contains("N"));
    setBusy(false);
  }

  void increaseTakeProfitPx({OrderResponseModel order}) {
    takeProfitPx += 1;
    takeProfit = OrderCalculate.getTakeProfit(
        takeProfitPx, order.boughtPx, order.strikePx, order.contractId.contains("N"));
    setBusy(false);
  }

  void decreaseTakeProfitPx({OrderResponseModel order}) {
    if (takeProfitPx.round() > 0) {
      takeProfitPx -= 1;
    }
    takeProfit = takeProfitPx == 0
        ? null
        : OrderCalculate.getTakeProfit(
            takeProfitPx, order.boughtPx, order.strikePx, order.contractId.contains("N"));
    setBusy(false);
  }

  void changeTakeProfitPx({double profitPrice, OrderResponseModel order}) {
    this.takeProfitPx = profitPrice ?? 0;
    takeProfit = takeProfitPx == 0
        ? null
        : OrderCalculate.getTakeProfit(
            takeProfitPx, order.boughtPx, order.strikePx, order.contractId.contains("N"));
    setBusy(false);
  }

  void increaseCutLoss({OrderResponseModel order}) {
    if (cutLoss == null) {
      cutLoss = 100;
    } else {
      if (cutLoss.round() < 100) {
        cutLoss += 1;
      }
    }
    cutLossPx = OrderCalculate.cutLossPx(
        cutLoss, order.boughtPx, order.strikePx, order.contractId.contains("N"));
    checkIfCutLossCorrect(order);
    setBusy(false);
  }

  void decreaseCutLoss({OrderResponseModel order}) {
    if (cutLoss == null) {
      cutLoss = 100;
    } else {
      if (cutLoss.round() > 0) {
        cutLoss -= 1;
      }
    }
    cutLossPx = OrderCalculate.cutLossPx(
        cutLoss, order.boughtPx, order.strikePx, order.contractId.contains("N"));
    checkIfCutLossCorrect(order);
    setBusy(false);
  }

  void changeCutLoss({double cutLoss, OrderResponseModel order}) {
    this.cutLoss = cutLoss;
    cutLossPx = cutLoss == null
        ? order.strikePx
        : OrderCalculate.cutLossPx(
            cutLoss, order.boughtPx, order.strikePx, order.contractId.contains("N"));
    checkIfCutLossCorrect(order);
    setBusy(false);
  }

  void increaseCutLossPx({OrderResponseModel order}) {
    if (cutLoss == null) {
      cutLossPx = order.forceClosePx;
    } else {
      cutLossPx += 1;
    }
    cutLoss = OrderCalculate.getCutLoss(
        cutLossPx, order.boughtPx, order.strikePx, order.contractId.contains("N"));
    checkIfCutLossCorrect(order);
    setBusy(false);
  }

  void decreaseCutLossPx({OrderResponseModel order}) {
    if (cutLoss == null) {
      cutLossPx = order.forceClosePx;
    } else {
      if (cutLossPx.round() > 0) {
        cutLossPx -= 1;
      }
    }
    cutLoss = OrderCalculate.getCutLoss(
        cutLossPx, order.boughtPx, order.strikePx, order.contractId.contains("N"));
    checkIfCutLossCorrect(order);
    setBusy(false);
  }

  void changeCutLossPx({double cutLossPx, OrderResponseModel order}) {
    this.cutLossPx = cutLossPx ?? order.strikePx;
    cutLoss = this.cutLossPx == order.strikePx
        ? (cutLossPx == null ? null : 100)
        : OrderCalculate.getCutLoss(
            this.cutLossPx, order.boughtPx, order.strikePx, order.contractId.contains("N"));
    checkIfCutLossCorrect(order);
    setBusy(false);
  }

  void checkIfCutLossCorrect(OrderResponseModel order) {
    if ((order.contractId.contains("N") && cutLossPx < order.strikePx) ||
        (order.contractId.contains("X") && cutLossPx > order.strikePx)) {
      isCutLossCorrect = false;
    } else {
      isCutLossCorrect = true;
    }
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
      print(error.toString());
      shouldShowErrorMessage = true;
      setBusy(false);
      return false;
    }
  }

  changeObscure() {
    isObscure = !isObscure;
    setBusy(false);
  }
}

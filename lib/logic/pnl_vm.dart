import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/helper/asset_utils.dart';
import 'package:bbb_flutter/helper/order_calculate_helper.dart';
import 'package:bbb_flutter/manager/market_manager.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/request/amend_order_request_model.dart';
import 'package:bbb_flutter/models/response/order_response_model.dart';
import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api_provider.dart';
import 'package:cybex_flutter_plugin/common.dart';
import 'package:cybex_flutter_plugin/cybex_flutter_plugin.dart';

class PnlViewModel extends BaseModel {
  double cutLoss;
  double takeProfit;
  bool shouldShowErrorMessage = false;

  BBBAPIProvider _api;
  UserManager _um;
  MarketManager _mtm;
  RefManager _refm;

  PnlViewModel(
      {BBBAPIProvider api,
      UserManager um,
      MarketManager mtm,
      RefManager refm}) {
    _api = api;
    _um = um;
    _mtm = mtm;
    _refm = refm;
  }

  Contract currentContract(OrderResponseModel order) {
    return _refm.getContractFromId(order.contractId);
  }

  Future amend(OrderResponseModel order, bool execNow) async {
    final ticker = _mtm.lastTicker.value;

    final contract = currentContract(order);

    final model = AmendOrderRequestModel();
    model.transactionType = "NxAmend";
    model.cutLossPx = execNow
        ? order.cutLossPx.toStringAsFixed(6)
        : OrderCalculate.cutLossPx(cutLoss, order.underlyingSpotPx,
                contract.strikeLevel, contract.conversionRate > 0)
            .toStringAsFixed(6);
    model.takeProfitPx = execNow
        ? order.takeProfitPx.toStringAsFixed(6)
        : OrderCalculate.takeProfitPx(takeProfit, order.underlyingSpotPx,
                contract.strikeLevel, contract.conversionRate > 0)
            .toStringAsFixed(6);
    model.seller = suffixId(_um.user.account.id);
    model.refBuyOrderTxId = order.buyOrderTxId;
    model.execNowPx = execNow ? "0" : ticker.value.toString();
    model.expiration = 0;

    final sig =
        await CybexFlutterPlugin.signMessageOperation(model.toStreamString());

    model.signature = sig.replaceAll("\"", "");

    print(model.toRawJson());
    final result = await _api.amendOrder(order: model);
    print(result.toRawJson());
  }

  void increaseTakeProfit() {
    if (takeProfit < 100) {
      takeProfit += 1;
      setBusy(false);
    }
  }

  void decreaseTakeProfit() {
    if (takeProfit > 1) {
      takeProfit -= 1;
      setBusy(false);
    }
  }

  void increaseCutLoss() {
    if (cutLoss < 100) {
      cutLoss += 1;
      setBusy(false);
    }
  }

  void decreaseCutLoss() {
    if (cutLoss > 1) {
      cutLoss -= 1;
      setBusy(false);
    }
  }

  Future<bool> checkPassword({String name, String password}) async {
    var account = await _um.unlockWith(name: name, password: password);
    if (account != null) {
      shouldShowErrorMessage = false;
      setBusy(false);
      return true;
    } else {
      shouldShowErrorMessage = true;
      setBusy(false);
      return false;
    }
  }
}

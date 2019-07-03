import 'dart:async';
import 'dart:math';

import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/helper/asset_utils.dart';
import 'package:bbb_flutter/helper/order_calculate_helper.dart';
import 'package:bbb_flutter/manager/market_manager.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/form/order_form_model.dart';
import 'package:bbb_flutter/models/request/post_order_request_model.dart';
import 'package:bbb_flutter/models/response/post_order_response_model.dart';
import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api_provider.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:cybex_flutter_plugin/commision.dart';
import 'package:cybex_flutter_plugin/cybex_flutter_plugin.dart';
import 'package:cybex_flutter_plugin/order.dart';
import 'package:logging/logging.dart';

class TradeViewModel extends BaseModel {
  OrderForm orderForm;
  bool isSatisfied;
  Contract get contract =>
      orderForm.isUp ? _refm.currentUpContract : _refm.currentDownContract;

  BBBAPIProvider _api;
  MarketManager _mtm;
  RefManager _refm;
  UserManager _um;

  StreamSubscription _refSub;
  StreamSubscription _lastTickerSub;

  TradeViewModel(
      {@required BBBAPIProvider api,
      @required MarketManager mtm,
      @required RefManager refm,
      @required UserManager um,
      this.orderForm}) {
    _api = api;
    _mtm = mtm;
    _refm = refm;
    _um = um;
    isSatisfied = true;

    _refSub = _refm.data.listen((onData) {
      updateAmountAndFee();
    });

    _lastTickerSub = _mtm.lastTicker.listen((onData) {
      updateAmountAndFee();
    });
  }

  @override
  dispose() {
    _refSub.cancel();
    _lastTickerSub.cancel();
    super.dispose();
  }

  initForm(bool isup) {
    orderForm = OrderForm(
        isUp: isup,
        cutoff: 50,
        takeProfit: 50,
        investAmount: 0,
        totalAmount: Asset(amount: 0, symbol: "USDT"),
        fee: Asset(amount: 0, symbol: "USDT"));
  }

  updateCurrentContract(bool isUp, String contractId) {
    if (isUp) {
      _refm.changeUpContractId(contractId);
    } else {
      _refm.changeDownContractId(contractId);
    }
    orderForm.isUp = isUp;
    updateAmountAndFee();
  }

  updateAmountAndFee() {
    var ticker = _mtm.lastTicker.value;
    var amount =
        (ticker.value - contract.strikeLevel) * contract.conversionRate;

    double commiDouble = orderForm.investAmount *
        ticker.value *
        contract.conversionRate.abs() *
        contract.commissionRate;

    double extra = 0.1;

    orderForm.fee = Asset(amount: commiDouble, symbol: contract.quoteAsset);
    double totalAmount = orderForm.investAmount * amount + extra;

    orderForm.totalAmount =
        Asset(amount: totalAmount + commiDouble, symbol: contract.quoteAsset);
    setBusy(false);
  }

  void increaseInvest() {
    var contract =
        orderForm.isUp ? _refm.currentUpContract : _refm.currentDownContract;

    if (orderForm.investAmount < contract.availableInventory) {
      orderForm.investAmount += 1;
      updateAmountAndFee();
    }
  }

  void decreaseInvest() {
    if (orderForm.investAmount > 0) {
      orderForm.investAmount -= 1;
      updateAmountAndFee();
    }
  }

  void increaseTakeProfit() {
    if (orderForm.takeProfit < 100) {
      orderForm.takeProfit += 1;
      setBusy(false);
    }
  }

  void decreaseTakeProfit() {
    if (orderForm.takeProfit > 1) {
      orderForm.takeProfit -= 1;
      setBusy(false);
    }
  }

  void increaseCutLoss() {
    if (orderForm.cutoff < 100) {
      orderForm.cutoff += 1;
      setBusy(false);
    }
  }

  void decreaseCutLoss() {
    if (orderForm.cutoff > 1) {
      orderForm.cutoff -= 1;
      setBusy(false);
    }
  }

  List<Contract> getUpContracts() {
    return _refm.upContract;
  }

  List<Contract> getDownContracts() {
    return _refm.downContract;
  }

  Future<PostOrderResponseModel> postOrder() async {
    var ticker = _mtm.lastTicker.value;
    var contract =
        orderForm.isUp ? _refm.currentUpContract : _refm.currentDownContract;

    final refData = _refm.lastData;

    PostOrderRequestModel order = PostOrderRequestModel();
    Order buyOrder = getBuyOrder(refData, contract);
    Commission commission = getCommission(refData, contract);

    order.buyOrder = buyOrder;
    order.commission = commission;

    order.underlyingSpotPx = ticker.value.toString();
    order.contractId = contract.contractId;
    order.expiration = 0;
    order.takeProfitPx = OrderCalculate.takeProfitPx(orderForm.takeProfit,
            ticker.value, contract.strikeLevel, orderForm.isUp)
        .toStringAsFixed(6);
    order.cutLossPx = OrderCalculate.cutLossPx(orderForm.cutoff, ticker.value,
            contract.strikeLevel, orderForm.isUp)
        .toStringAsFixed(6);

    order.buyOrder =
        await CybexFlutterPlugin.limitOrderCreateOperation(buyOrder, true);

    order.commission = await CybexFlutterPlugin.transferOperation(commission);

    order.buyOrderTxId = order.buyOrder.transactionid;
    locator.get<Logger>().info(order.toRawJson());

    PostOrderResponseModel res = await _api.postOrder(order: order);
    locator.get<Logger>().warning(res.toRawJson());

    return Future.value(res);
  }

  Order getBuyOrder(RefContractResponseModel refData, Contract contract) {
    OrderForm form = orderForm;
    AvailableAsset quoteAsset = refData.availableAssets
        .where((asset) {
          return asset.assetName == contract.quoteAsset;
        })
        .toList()
        .first;

    AvailableAsset baseAsset = refData.availableAssets
        .where((asset) {
          return asset.assetName == contract.assetName;
        })
        .toList()
        .first;

    int expir = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
    var amount = (form.totalAmount.amount - form.fee.amount) *
        pow(10, quoteAsset.precision);
    AmountToSell buyAmount = AmountToSell(
        amount: amount.toInt(), assetId: suffixId(quoteAsset.assetId));

    Order order = Order();
    order.chainid = refData.chainId;
    order.refBlockNum = refData.refBlockNum;
    order.refBlockPrefix = refData.refBlockPrefix;
    order.refBlockId = refData.refBlockId;
    order.fee = AssetDef.CYB;
    order.seller = suffixId(_um.user.account.id);
    order.amountToSell = buyAmount;
    order.minToReceive = AmountToSell(
        amount: form.investAmount, assetId: suffixId(baseAsset.assetId));
    order.fillOrKill = 1;
    order.txExpiration = expir + 5 * 60;
    order.expiration = expir + 5 * 60;
    return order;
  }

  Commission getCommission(
      RefContractResponseModel refData, Contract contract) {
    OrderForm form = orderForm;
    AvailableAsset quoteAsset = refData.availableAssets
        .where((asset) {
          return asset.assetName == contract.quoteAsset;
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
    comm.fee = AssetDef.CYB;
    comm.from = suffixId(_um.user.account.id);
    comm.to = suffixId(refData.accountKeysEntityOperator.accountId);
    comm.amount = AmountToSell(
        assetId: suffixId(quoteAsset.assetId),
        amount: (form.fee.amount * pow(10, quoteAsset.precision)).toInt());

    return comm;
  }
}

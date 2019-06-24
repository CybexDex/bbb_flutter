import 'dart:math';

import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/helper/log_helper.dart';
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

class TradeViewModel extends BaseModel {
  OrderForm orderForm;
  BBBAPIProvider _api;
  MarketManager _mtm;
  RefManager _refm;
  UserManager _um;

  TradeViewModel(
      {@required BBBAPIProvider api,
      @required MarketManager mtm,
      @required RefManager refm,
      @required UserManager um,
      this.orderForm})
      : _api = api,
        _mtm = mtm,
        _refm = refm,
        _um = um;

  updateAmountAndFee() {
    var contract = _refm.currentContract;
    var ticker = _mtm.lastTicker;
    var amount =
        (ticker.value - contract.strikeLevel) * contract.conversionRate;

    double commiDouble = orderForm.investAmount *
        ticker.value *
        contract.conversionRate *
        contract.commissionRate;

    orderForm.fee = Asset(amount: commiDouble, symbol: contract.quoteAsset);
    double totalAmount = orderForm.investAmount * amount;

    orderForm.totalAmount =
        Asset(amount: totalAmount + commiDouble, symbol: contract.quoteAsset);
    setBusy(false);
  }

  void increaseInvest() {
    var contract = _refm.currentContract;

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
      orderForm.takeProfit += 10;
      setBusy(false);
    }
  }

  void decreaseTakeProfit() {
    if (orderForm.takeProfit > 10) {
      orderForm.takeProfit -= 10;
      setBusy(false);
    }
  }

  void increaseCutLoss() {
    if (orderForm.cutoff < 100) {
      orderForm.cutoff += 10;
      setBusy(false);
    }
  }

  void decreaseCutLoss() {
    if (orderForm.cutoff > 10) {
      orderForm.cutoff -= 10;
      setBusy(false);
    }
  }

  Future<PostOrderResponseModel> postOrder() async {
    var ticker = _mtm.lastTicker;
    var contract = _refm.currentContract;

    final refData = _refm.lastData;

    PostOrderRequestModel order = PostOrderRequestModel();
    Order buyOrder = getBuyOrder(refData, contract);
    Order sellOrder = getSellOrder(refData, contract);
    Commission commission = getCommission(refData, contract);

    order.buyOrder = buyOrder;
    order.sellOrder = sellOrder;
    order.commission = commission;

    order.underlyingSpotPx = ticker.value.toString();
    order.contractId = contract.contractId;
    order.expiration =
        (DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000) + 24 * 60 * 60;

    order.buyOrder =
        await CybexFlutterPlugin.limitOrderCreateOperation(buyOrder);
    order.sellOrder =
        await CybexFlutterPlugin.limitOrderCreateOperation(sellOrder);
    order.commission = await CybexFlutterPlugin.transferOperation(commission);

    order.buyOrderTxId = order.buyOrder.transactionid;

    order.sellOrderTxId = order.sellOrder.transactionid;

    PostOrderResponseModel res = await _api.postOrder(order: order);
    // locator.get<Log>().printWrapped(res.toRawJson());

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
    AmountToSell buyAmount =
        AmountToSell(amount: amount.toInt(), assetId: quoteAsset.assetId);

    Order order = Order();
    order.chainid = refData.chainId;
    order.refBlockNum = refData.refBlockNum;
    order.refBlockPrefix = refData.refBlockPrefix;
    order.refBlockId = refData.refBlockId;
    order.fee = AssetDef.CYB;
    order.seller = _um.user.account.id;
    order.amountToSell = buyAmount;
    order.minToReceive =
        AmountToSell(amount: form.investAmount, assetId: baseAsset.assetId);
    order.fillOrKill = 1;
    order.txExpiration = expir + 5 * 60;
    order.expiration = expir + 5 * 60;
    return order;
  }

  Order getSellOrder(RefContractResponseModel refData, Contract contract) {
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
    Order order = Order();
    order.chainid = refData.chainId;
    order.refBlockNum = refData.refBlockNum;
    order.refBlockId = refData.refBlockId;
    order.refBlockPrefix = refData.refBlockPrefix;
    order.fee = AssetDef.CYB;
    order.seller = _um.user.account.id;
    order.amountToSell =
        AmountToSell(amount: form.investAmount, assetId: baseAsset.assetId);
    order.minToReceive =
        AmountToSell(amount: 1 * pow(10, 6), assetId: quoteAsset.assetId);
    order.fillOrKill = 1;
    order.txExpiration = expir + 365 * 24 * 60 * 60;
    order.expiration = 0;
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
    comm.from = _um.user.account.id;
    comm.to = refData.accountKeysEntityOperator.accountId;
    comm.amount = AmountToSell(
        assetId: quoteAsset.assetId, amount: (form.fee.amount).toInt());

    return comm;
  }
}

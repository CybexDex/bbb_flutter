import 'dart:async';
import 'dart:math';

import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/cache/shared_pref.dart';
import 'package:bbb_flutter/helper/asset_utils.dart';
import 'package:bbb_flutter/manager/market_manager.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/form/order_form_model.dart';
import 'package:bbb_flutter/models/request/post_order_request_model.dart';
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

class TradeViewModel extends BaseModel {
  OrderForm orderForm;
  bool isSatisfied;
  bool isTakeProfitInputCorrect = true;
  bool isCutLossInputCorrect = true;
  bool isInvestAmountInputCorrect = true;
  bool isCutLossCorrect = true;
  Contract get contract =>
      orderForm.isUp ? _refm.currentUpContract : _refm.currentDownContract;
  var ticker;
  var currentTicker;
  Contract saveContract;
  PostOrderRequestModel order;
  Order buyOrder;
  Commission commission;
  double actLevel = 0;
  Position usdtBalance;

  BBBAPI _api;
  MarketManager _mtm;
  RefManager _refm;
  UserManager _um;

  StreamSubscription _refSub;
  StreamSubscription _lastTickerSub;

  TradeViewModel(
      {@required BBBAPI api,
      @required MarketManager mtm,
      @required RefManager refm,
      @required UserManager um,
      this.orderForm}) {
    _api = api;
    _mtm = mtm;
    _refm = refm;
    _um = um;
    isSatisfied = true;
    currentTicker = _mtm.lastTicker.value;

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
        investAmount: 1,
        showCutoff: false,
        showProfit: false,
        totalAmount: Asset(amount: 0, symbol: AssetName.USDT),
        cybBalance: Position(assetName: AssetName.CYB, quantity: 0),
        fee: Asset(amount: 0, symbol: AssetName.USDT));
  }

  updateCurrentContract(bool isUp, String contractId) {
    print("ddd");
    if (isUp) {
      _refm.changeUpContractId(contractId);
    } else {
      _refm.changeDownContractId(contractId);
    }
    orderForm.investAmount = 1;
    orderForm.isUp = isUp;
    updateAmountAndFee();
  }

  updateAmountAndFee() {
    var ticker = _mtm.lastTicker.value;
    if (ticker == null) {
      return;
    }
    currentTicker = ticker;
    actLevel = orderForm.isUp
        ? (ticker.value / (ticker.value - _refm.currentUpContract.strikeLevel))
        : (ticker.value /
            (_refm.currentDownContract.strikeLevel - ticker.value));

    double extra = 0.1;

    var amount =
        (ticker.value - contract.strikeLevel) * contract.conversionRate + extra;

    double commiDouble = orderForm.investAmount *
        ticker.value *
        contract.conversionRate.abs() *
        contract.commissionRate;

    orderForm.fee = Asset(amount: commiDouble, symbol: contract.quoteAsset);
    double totalAmount = orderForm.investAmount * amount;

    orderForm.totalAmount =
        Asset(amount: totalAmount + commiDouble, symbol: contract.quoteAsset);
    if (orderForm.investAmount > contract.availableInventory ||
        _um.fetchPositionFrom(AssetName.NXUSDT) == null ||
        orderForm.totalAmount.amount >
            _um.fetchPositionFrom(AssetName.NXUSDT).quantity ||
        orderForm.investAmount > contract.maxOrderQty ||
        orderForm.totalAmount.amount <= double.minPositive ||
        !isTakeProfitInputCorrect ||
        !isCutLossInputCorrect ||
        !isInvestAmountInputCorrect ||
        !isCutLossCorrect) {
      isSatisfied = false;
    } else {
      isSatisfied = true;
    }
    setBusy(false);
  }

  void changeInvest({int amount}) {
    orderForm.investAmount = amount;
    updateAmountAndFee();
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
    if (orderForm.takeProfit == null) {
      orderForm.takeProfit = 50;
      orderForm.showProfit = true;
      isTakeProfitInputCorrect = true;
    } else {
      orderForm.takeProfit += 1;
    }
    setBusy(false);
  }

  void decreaseTakeProfit() {
    if (orderForm.takeProfit == null) {
      orderForm.takeProfit = 50;
      orderForm.showProfit = true;
      isTakeProfitInputCorrect = true;
    } else {
      if (orderForm.takeProfit.round() > 0) {
        orderForm.takeProfit -= 1;
      }
    }
    setBusy(false);
  }

  void changeTakeProfit({double profit}) {
    if (profit == null) {
      orderForm.showProfit = false;
      isTakeProfitInputCorrect = true;
    } else {
      orderForm.showProfit = true;
    }

    orderForm.takeProfit = profit;
    setBusy(false);
  }

  void increaseTakeProfitPx() {
    if (orderForm.takeProfitPx == null) {
      orderForm.takeProfitPx = 1;
      orderForm.showProfit = true;
      isTakeProfitInputCorrect = true;
    } else {
      orderForm.takeProfitPx += 1;
    }
    setBusy(false);
  }

  void decreaseTakeProfitPx() {
    if (orderForm.takeProfitPx == null) {
      return;
    } else {
      if (orderForm.takeProfitPx.round() > 0) {
        orderForm.showProfit = true;
        isTakeProfitInputCorrect = true;
        orderForm.takeProfitPx -= 1;
      }
    }
    setBusy(false);
  }

  void changeTakeProfitPx({double profit}) {
    if (profit == null) {
      orderForm.showProfit = false;
      isTakeProfitInputCorrect = true;
    } else {
      orderForm.showProfit = true;
    }

    orderForm.takeProfitPx = profit;
    setBusy(false);
  }

  void increaseCutLoss() {
    if (orderForm.cutoff == null) {
      orderForm.showCutoff = true;
      orderForm.cutoff = 50;
      isCutLossInputCorrect = true;
    } else {
      if (orderForm.cutoff.round() < 100) {
        orderForm.cutoff += 1;
      }
    }
    setBusy(false);
  }

  void decreaseCutLoss() {
    if (orderForm.cutoff == null) {
      orderForm.showCutoff = true;
      orderForm.cutoff = 50;
      isCutLossInputCorrect = true;
    } else {
      if (orderForm.cutoff.round() > 0) {
        orderForm.cutoff -= 1;
      }
    }
    setBusy(false);
  }

  void changeCutLoss({double cutLoss}) {
    if (cutLoss == null) {
      orderForm.showCutoff = false;
      isCutLossInputCorrect = true;
    } else {
      orderForm.showCutoff = true;
    }
    orderForm.cutoff = cutLoss;
    setBusy(false);
  }

  void increaseCutLossPx() {
    if (orderForm.cutoffPx == null) {
      orderForm.showCutoff = true;
      orderForm.cutoffPx = contract.strikeLevel + 1;
      isCutLossInputCorrect = true;
    } else {
      orderForm.cutoffPx += 1;
    }
    checkIfCutLossCorrect();
    updateAmountAndFee();
    setBusy(false);
  }

  void decreaseCutLossPx() {
    if (orderForm.cutoffPx == null) {
      orderForm.showCutoff = true;
      orderForm.cutoffPx = contract.strikeLevel - 1;
      isCutLossInputCorrect = true;
    } else {
      if (orderForm.cutoffPx.round() > 0) {
        orderForm.cutoffPx -= 1;
      }
    }
    checkIfCutLossCorrect();
    setBusy(false);
  }

  void changeCutLossPx({double cutLoss}) {
    if (cutLoss == null) {
      orderForm.showCutoff = false;
      isCutLossInputCorrect = true;
    } else {
      orderForm.showCutoff = true;
    }
    orderForm.cutoffPx = cutLoss;
    checkIfCutLossCorrect();
    setBusy(false);
  }

  void checkIfCutLossCorrect() {
    if (orderForm.cutoffPx != null &&
        ((orderForm.isUp && orderForm.cutoffPx < contract.strikeLevel) ||
            (!orderForm.isUp && orderForm.cutoffPx > contract.strikeLevel))) {
      isCutLossCorrect = false;
    } else {
      isCutLossCorrect = true;
    }
    updateAmountAndFee();
  }

  List<Contract> getUpContracts() {
    return _refm.upContract;
  }

  List<Contract> getDownContracts() {
    return _refm.downContract;
  }

  fetchPostion({String name}) async {
    await _um.fetchBalances(name: _um.user.name);
    usdtBalance = _um.fetchPositionFrom(name);
    orderForm.cybBalance = _um.fetchPositionFrom(AssetName.CYB) ??
        Position(assetName: AssetName.CYB, quantity: 0);
    setBusy(false);
  }

  void setTakeProfitInputCorrectness(bool value) {
    isTakeProfitInputCorrect = value;
    updateAmountAndFee();
  }

  void setCutLossInputCorectness(bool value) {
    isCutLossInputCorrect = value;
    updateAmountAndFee();
  }

  void setTotalAmountInputCorectness(bool value) {
    isInvestAmountInputCorrect = value;
    updateAmountAndFee();
  }

  Future<PostOrderResponseModel> postOrder() async {
    order.buyOrder = buyOrder;
    order.commission = commission;

    order.underlyingSpotPx = ticker.value.toString();
    order.contractId = saveContract.contractId;
    order.expiration = _um.user.testAccountResponseModel != null &&
            _um.user.testAccountResponseModel.accountType >= 1
        ? _um.user.testAccountResponseModel.expiration
        : 0;
    order.takeProfitPx = orderForm.takeProfitPx == null
        ? "0"
        : orderForm.takeProfitPx.toStringAsFixed(4);
    // : OrderCalculate.takeProfitPx(orderForm.takeProfit, ticker.value,
    //         saveContract.strikeLevel, orderForm.isUp)
    //     .toStringAsFixed(4);
    order.cutLossPx = orderForm.cutoffPx == null
        ? saveContract.strikeLevel.toStringAsFixed(4)
        : orderForm.cutoffPx.toStringAsFixed(4);
    // : OrderCalculate.cutLossPx(orderForm.cutoff, ticker.value,
    //         saveContract.strikeLevel, orderForm.isUp)
    //     .toStringAsFixed(4);

    order.buyOrder =
        await CybexFlutterPlugin.limitOrderCreateOperation(buyOrder, true);

    if (_um.user.testAccountResponseModel != null) {
      await CybexFlutterPlugin.setDefaultPrivKey(
          _um.user.testAccountResponseModel.privateKey);
    }

    order.commission = await CybexFlutterPlugin.transferOperation(commission);

    order.buyOrderTxId = order.buyOrder.transactionid;
    locator.get<Logger>().i(order.toRawJson());
    print(order.cutLossPx);

    PostOrderResponseModel res = await _api.postOrder(order: order);
    locator.get<Logger>().w(res.toRawJson());

    return res;
  }

  void saveOrder() {
    ticker = _mtm.lastTicker.value;
    saveContract =
        orderForm.isUp ? _refm.currentUpContract : _refm.currentDownContract;

    final refData = _refm.lastData;

    order = PostOrderRequestModel();
    buyOrder = getBuyOrder(refData, contract);
    commission = getCommission(refData, contract);
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
    order.fee = AssetDef.cyb;
    order.seller = suffixId(locator.get<SharedPref>().getTestNet()
        ? _um.user.testAccountResponseModel.accountId
        : _um.user.account.id);
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
    comm.fee = AssetDef.cybTransfer;
    comm.from = suffixId(locator.get<SharedPref>().getTestNet()
        ? _um.user.testAccountResponseModel.accountId
        : _um.user.account.id);
    comm.to = suffixId(refData.accountKeysEntityOperator.accountId);
    comm.amount = AmountToSell(
        assetId: suffixId(quoteAsset.assetId),
        amount: (form.fee.amount * pow(10, quoteAsset.precision)).toInt());

    return comm;
  }
}

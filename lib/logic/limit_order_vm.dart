import 'dart:async';
import 'dart:math';

import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/cache/shared_pref.dart';
import 'package:bbb_flutter/helper/asset_utils.dart';
import 'package:bbb_flutter/helper/utils.dart';
import 'package:bbb_flutter/manager/market_manager.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/entity/available_assets.dart';
import 'package:bbb_flutter/models/form/limit_order_form_model.dart';
import 'package:bbb_flutter/models/form/order_form_model.dart';
import 'package:bbb_flutter/models/request/open_limit_order_request_model.dart' as prefix;
import 'package:bbb_flutter/models/request/open_order_request.dart';
import 'package:bbb_flutter/models/response/bbb_query_response/contract_response.dart';
import 'package:bbb_flutter/models/response/bbb_query_response/refData_response.dart';
import 'package:bbb_flutter/models/response/positions_response_model.dart';
import 'package:bbb_flutter/models/response/post_order_response_model.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:cybex_flutter_plugin/commision.dart';
import 'package:cybex_flutter_plugin/cybex_flutter_plugin.dart';
import 'package:bbb_flutter/widgets/custom_dropdown.dart' as custom;
import 'package:cybex_flutter_plugin/order.dart';
import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';

class LimitOrderViewModel extends BaseModel {
  LimitOrderForm orderForm;
  bool isSatisfied;
  bool isInvestAmountInputCorrect = true;
  bool isTakeProfitInputCorrect = true;
  bool isCutLossInputCorrect = true;
  bool isCutLossCorrect = true;
  bool isMarket = true;
  bool changeCutLoss = false;
  bool isChangeSide = false;
  var ticker;
  var currentTicker;
  var priceFloating;
  prefix.OpenLimitOrderRequestModel order;
  OpenOrderRequest marketOrder;
  Commission commission;
  double actLevel = 0;
  Position usdtBalance;
  Contract saveContract;
  double savedAmount;

  BBBAPI _api;
  MarketManager _mtm;
  RefManager _refm;
  UserManager _um;

  StreamSubscription _lastTickerSub;

  LimitOrderViewModel(
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
    priceFloating = _refm.underlyingList
        .firstWhere((value) => value.underlying == locator.get<SharedPref>().getAsset())
        .priceFloating;
  }

  @override
  dispose() {
    _lastTickerSub.cancel();
    super.dispose();
  }

  initForm(bool isup) {
    orderForm = LimitOrderForm(
        isUp: isup,
        investAmount: 1,
        showCutoff: false,
        showProfit: false,
        totalAmount: Asset(amount: 0),
        cybBalance: Position(quantity: 0),
        fee: Asset(amount: 0));

    _lastTickerSub = _mtm.lastTicker.listen((onData) {
      updateAmountAndFee();
      if (isMarket) {
        buildPickerMenuItem(contractIds);
      }
    });
  }

  Contract get contract => orderForm.selectedItem;

  List<Contract> get contractIds {
    if (isMarket) {
      if (orderForm.isUp) {
        return _refm.upContract;
      } else {
        return _refm.downContract;
      }
    } else {
      if (orderForm.predictPrice != null) {
        if (orderForm.isUp) {
          return _refm.allUpContract.where((contract) {
            return (orderForm.predictPrice > contract.strikeLevel) &&
                ((orderForm.predictPrice /
                        ((orderForm.predictPrice - contract.strikeLevel).abs())) <=
                    _refm.config.maxGearing);
          }).toList();
        } else {
          return _refm.allDownContract.where((contract) {
            return (orderForm.predictPrice < contract.strikeLevel) &&
                ((orderForm.predictPrice /
                        ((orderForm.predictPrice - contract.strikeLevel).abs())) <=
                    _refm.config.maxGearing);
          }).toList();
        }
      }
    }
    return null;
  }

  changeModel({bool value}) {
    isMarket = value;
    if (isMarket) {
      buildDropdownMenuItems(contractIds);
      buildPickerMenuItem(contractIds);
    } else {
      buildDropdownMenuItems(null);
      buildPickerMenuItem(null);
    }
    orderForm.predictPrice = null;
    orderForm.cutoffPx = null;
    orderForm.takeProfitPx = null;
    orderForm.investAmount = 1;
    setBusy(false);
  }

  buildDropdownMenuItems(List contracts) {
    if (contracts != null && contracts.isNotEmpty) {
      List<custom.DropdownMenuItem<Contract>> items = List();
      for (Contract contract in contracts) {
        items.add(
          custom.DropdownMenuItem(
            value: contract,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(contract.strikeLevel.toStringAsFixed(0), style: StyleNewFactory.grey14),
            ),
          ),
        );
      }
      orderForm.dropdownMenuItems = items;
      orderForm.selectedItem = items[0].value;
      updateCurrentContract(orderForm.isUp, orderForm.selectedItem.contractId);
    } else {
      orderForm.dropdownMenuItems = null;
      orderForm.selectedItem = null;
      orderForm.totalAmount.amount = 0;
      setBusy(false);
    }
  }

  buildPickerMenuItem(List contracts) {
    if (contracts != null && contracts.isNotEmpty) {
      List<Widget> items = List();
      for (Contract contract in contracts) {
        items.add(Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(contract.strikeLevel.toStringAsFixed(0), style: StyleNewFactory.grey14),
              Text(
                  orderForm.isUp
                      ? ((isMarket ? currentTicker.value : orderForm.predictPrice) /
                              ((isMarket ? currentTicker.value : orderForm.predictPrice) -
                                  contract.strikeLevel))
                          .toStringAsFixed(1)
                      : ((isMarket ? currentTicker.value : orderForm.predictPrice) /
                              (contract.strikeLevel -
                                  (isMarket ? currentTicker.value : orderForm.predictPrice)))
                          .toStringAsFixed(1),
                  style: StyleNewFactory.grey14),
            ],
          ),
        ));
      }
      orderForm.pickerItems = items;
    } else {
      orderForm.dropdownMenuItems = null;
      orderForm.selectedItem = null;
      orderForm.totalAmount.amount = 0;
      orderForm.pickerItems = [];
      setBusy(false);
    }
  }

  onChnageDropdownSelection(Contract selected) {
    orderForm.selectedItem = selected;
    changeCutLoss = true;
    updateCurrentContract(orderForm.isUp, orderForm.selectedItem.contractId);
  }

  changePredictPrice(double price) {
    if (price == null) {
      orderForm.predictPrice = null;
    } else {
      orderForm.predictPrice = price;
    }
    setBusy(false);
  }

  updateCurrentContract(bool isUp, String contractId) {
    orderForm.isUp = isUp;
    updateAmountAndFee();
  }

  updateSide() {
    orderForm.isUp = !orderForm.isUp;
    isChangeSide = true;
    setBusy(false);
    buildDropdownMenuItems(contractIds);
  }

  updateAmountAndFee() {
    var ticker = _mtm.lastTicker.value;
    if (ticker == null || contract == null) {
      return;
    }
    currentTicker = ticker;
    actLevel = orderForm.isUp
        ? ((isMarket ? ticker.value : orderForm.predictPrice) /
            ((isMarket ? ticker.value : orderForm.predictPrice) - contract.strikeLevel))
        : ((isMarket ? ticker.value : orderForm.predictPrice) /
            (contract.strikeLevel - (isMarket ? ticker.value : orderForm.predictPrice)));

    var amount = ((orderForm.isUp
                    ? ((isMarket ? ticker.value : orderForm.predictPrice) + priceFloating)
                    : ((isMarket ? ticker.value : orderForm.predictPrice) - priceFloating)) -
                contract.strikeLevel)
            .abs() *
        contract.conversionRate.abs();

    double commiDouble = orderForm.investAmount *
        (isMarket ? ticker.value : orderForm.predictPrice) *
        contract.conversionRate.abs() *
        contract.commissionRate;

    orderForm.fee = Asset(amount: commiDouble);
    double totalAmount = orderForm.investAmount * amount;

    orderForm.totalAmount = Asset(amount: totalAmount + commiDouble);
    if (_um.fetchPositionFrom(_refm.refDataControllerNew.value.bbbAssetId) == null ||
        orderForm.totalAmount.amount >
            _um.fetchPositionFrom(_refm.refDataControllerNew.value.bbbAssetId).quantity ||
        orderForm.investAmount > _refm.config.maxOrderQuantity ||
        orderForm.totalAmount.amount <= double.minPositive ||
        !isInvestAmountInputCorrect ||
        !isTakeProfitInputCorrect ||
        !isCutLossInputCorrect ||
        !isCutLossCorrect) {
      isSatisfied = false;
    } else {
      isSatisfied = true;
    }
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

  void increaseCutLossPx() {
    if (orderForm.cutoffPx == null) {
      orderForm.showCutoff = true;
      orderForm.cutoffPx = contract.strikeLevel.toDouble() + 1;
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
      orderForm.cutoffPx = contract.strikeLevel.toDouble() - 1;
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

  void changeInvest({int amount}) {
    orderForm.investAmount = amount;
    updateAmountAndFee();
  }

  void increaseInvest() {
    orderForm.investAmount += 1;
    updateAmountAndFee();
  }

  void decreaseInvest() {
    if (orderForm.investAmount > 0) {
      orderForm.investAmount -= 1;
      updateAmountAndFee();
    }
  }

  List<Contract> getUpContracts() {
    return _refm.upContract;
  }

  List<Contract> getDownContracts() {
    return _refm.downContract;
  }

  fetchPostion() async {
    await _um.fetchBalances(name: _um.user.name);
    usdtBalance = _um.fetchPositionFrom(_refm.refDataControllerNew.value.bbbAssetId);
    orderForm.cybBalance = _um.fetchPositionFrom(AssetId.CYB) ?? Position(quantity: 0);
    setBusy(false);
  }

  void setTotalAmountInputCorectness(bool value) {
    isInvestAmountInputCorrect = value;
    updateAmountAndFee();
  }

  void setTakeProfitInputCorrectness(bool value) {
    isTakeProfitInputCorrect = value;
    updateAmountAndFee();
  }

  void setCutLossInputCorectness(bool value) {
    isCutLossInputCorrect = value;
    updateAmountAndFee();
  }

  Future<PostOrderResponseModel> postOrder() async {
    if (_um.user.testAccountResponseModel != null) {
      CybexFlutterPlugin.setDefaultPrivKey(_um.user.testAccountResponseModel.privkey);
    }

    commission = getCommission(_refm.refDataControllerNew.value, contract);

    int expir = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
    order.data.action = locator.get<SharedPref>().getAction();
    order.data.user = _um.user.testAccountResponseModel != null
        ? _um.user.testAccountResponseModel.name
        : _um.user.account.name;
    order.data.contract = orderForm.selectedItem.contractId;
    order.data.takeProfitPrice =
        orderForm.takeProfitPx == null ? "0" : orderForm.takeProfitPx.toStringAsFixed(4);
    order.data.cutlossPrice = orderForm.cutoffPx == null
        ? contract.strikeLevel.toStringAsFixed(4)
        : orderForm.cutoffPx.toStringAsFixed(4);

    order.data.quantity = orderForm.investAmount;
    order.data.paid = (orderForm.totalAmount.amount).toStringAsFixed(4);
    order.data.timeout = expir + 5 * 60;
    order.data.deadline =
        DateFormat("yyyy-MM-ddTHH:mm:ss").format(DateTime.now().toUtc().add(Duration(days: 1)));
    order.data.lowestTriggerPrice =
        orderForm.predictPrice > ticker.value ? orderForm.predictPrice.toStringAsFixed(4) : "0";
    order.data.highestTriggerPrice =
        orderForm.predictPrice < ticker.value ? orderForm.predictPrice.toStringAsFixed(4) : "0";

    var data = order.data.toJson();
    String sig = await CybexFlutterPlugin.signMessageOperation(
        getQueryStringFromJson(data, data.keys.toList()..sort()));
    order.signature = sig.contains('\"') ? sig.substring(1, sig.length - 1) : sig;
    var orderRequest = order.toJson();
    if (locator.get<SharedPref>().getAction() == "main") {
      if (_um.user.keys == null) {
        await CybexFlutterPlugin.setDefaultPrivKey(_um.user.privateKey);
      }
      Map<String, dynamic> transaction = await CybexFlutterPlugin.transferOperation(commission);
      orderRequest["transaction"] = transaction;
    }
    print(orderRequest);
    PostOrderResponseModel result = await _api.postLimitOrder(requestLimitOrder: orderRequest);
    return result;
  }

  void saveOrder() {
    ticker = _mtm.lastTicker.value;
    order = prefix.OpenLimitOrderRequestModel(data: prefix.Data());
  }

  void saveMarketOrder() {
    ticker = _mtm.lastTicker.value;
    saveContract = orderForm.isUp ? _refm.currentUpContract : _refm.currentDownContract;

    final refData = _refm.refDataControllerNew.value;
    savedAmount = orderForm.totalAmount.amount;
    marketOrder = OpenOrderRequest(data: Data());
    if (locator.get<SharedPref>().getAction() == "main") {
      commission = getMarketCommission(refData, contract);
    }
  }

  Future<PostOrderResponseModel> postMarketOrder() async {
    if (_um.user.testAccountResponseModel != null) {
      CybexFlutterPlugin.setDefaultPrivKey(_um.user.testAccountResponseModel.privkey);
    }
    int expir = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
    marketOrder.data.action = locator.get<SharedPref>().getAction();
    marketOrder.data.user = _um.user.testAccountResponseModel != null
        ? _um.user.testAccountResponseModel.name
        : _um.user.account.name;
    marketOrder.data.contract = orderForm.selectedItem.contractId;
    marketOrder.data.takeProfitPrice =
        orderForm.takeProfitPx == null ? "0" : orderForm.takeProfitPx.toStringAsFixed(4);

    marketOrder.data.cutlossPrice = orderForm.cutoffPx == null
        ? orderForm.selectedItem.strikeLevel.toStringAsFixed(4)
        : orderForm.cutoffPx.toStringAsFixed(4);

    marketOrder.data.quantity = orderForm.investAmount;
    marketOrder.data.paid = (savedAmount).toStringAsFixed(4);
    marketOrder.data.timeout = expir + 5 * 60;

    var data = marketOrder.data.toJson();
    String sig = await CybexFlutterPlugin.signMessageOperation(
        getQueryStringFromJson(data, data.keys.toList()..sort()));
    marketOrder.signature = sig.contains('\"') ? sig.substring(1, sig.length - 1) : sig;
    var orderRequest = marketOrder.toJson();
    if (locator.get<SharedPref>().getAction() == "main") {
      if (_um.user.keys == null) {
        await CybexFlutterPlugin.setDefaultPrivKey(_um.user.privateKey);
      }
      Map<String, dynamic> transaction = await CybexFlutterPlugin.transferOperation(commission);
      orderRequest["transaction"] = transaction;
    }
    print(orderRequest);
    PostOrderResponseModel result = await _api.postOrder(requestOrder: orderRequest);
    return result;
  }

  Commission getCommission(RefDataResponse refData, Contract contract) {
    AvailableAsset quoteAsset =
        AvailableAsset(assetId: refData.bbbAssetId, precision: refData.bbbAssetPrecision);
    int expir = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;

    Commission comm = Commission();
    comm.chainid = refData.chainId;
    comm.refBlockNum = refData.blockNum;
    comm.refBlockId = refData.blockId;

    comm.txExpiration = expir + 12 * 60 * 60;
    comm.fee = AssetDef.cybTransfer;
    comm.from = suffixId(locator.get<SharedPref>().getAction() == "test"
        ? _um.user.testAccountResponseModel.name
        : _um.user.account.id);
    comm.to = suffixId(refData.adminAccountId);
    comm.amount = AmountToSell(
        assetId: suffixId(quoteAsset.assetId),
        amount: ((Decimal.parse(orderForm.totalAmount.amount.toStringAsFixed(4))) *
                Decimal.parse(pow(10, quoteAsset.precision).toString()))
            .toInt());
    comm.isTwo = false;
    return comm;
  }

  Commission getMarketCommission(RefDataResponse refData, Contract contract) {
    AvailableAsset quoteAsset =
        AvailableAsset(assetId: refData.bbbAssetId, precision: refData.bbbAssetPrecision);
    int expir = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;

    Commission comm = Commission();
    comm.chainid = refData.chainId;
    comm.refBlockNum = refData.blockNum;
    comm.refBlockId = refData.blockId;

    comm.txExpiration = expir + 12 * 60 * 60;
    comm.fee = AssetDef.cybTransfer;
    comm.from = suffixId(locator.get<SharedPref>().getAction() == "test"
        ? _um.user.testAccountResponseModel.name
        : _um.user.account.id);
    comm.to = suffixId(refData.adminAccountId);
    comm.amount = AmountToSell(
        assetId: suffixId(quoteAsset.assetId),
        amount: ((Decimal.parse(savedAmount.toStringAsFixed(4))) *
                Decimal.parse(pow(10, quoteAsset.precision).toString()))
            .toInt());
    comm.isTwo = false;
    return comm;
  }
}

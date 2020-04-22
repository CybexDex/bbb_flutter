import 'dart:async';
import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/helper/utils.dart';
import 'package:bbb_flutter/manager/market_manager.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/form/limit_order_form_model.dart';
import 'package:bbb_flutter/models/form/order_form_model.dart';
import 'package:bbb_flutter/models/request/open_limit_order_request_model.dart' as prefix;
import 'package:bbb_flutter/models/request/open_reward_request_model.dart';
import 'package:bbb_flutter/models/response/bbb_query_response/contract_response.dart';
import 'package:bbb_flutter/models/response/bbb_query_response/coupon_response.dart';
import 'package:bbb_flutter/models/response/positions_response_model.dart';
import 'package:bbb_flutter/models/response/post_order_response_model.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:cybex_flutter_plugin/commision.dart';
import 'package:cybex_flutter_plugin/cybex_flutter_plugin.dart';
import 'package:bbb_flutter/widgets/custom_dropdown.dart' as custom;

import 'coupon_vm.dart';

class CouponOrderViewModel extends BaseModel {
  LimitOrderForm orderForm;
  bool isSatisfied;
  bool isInvestAmountInputCorrect = true;
  bool isTakeProfitInputCorrect = true;
  bool isCutLossInputCorrect = true;
  bool isCutLossCorrect = true;
  bool changeCutLoss = false;
  var ticker;
  var currentTicker;
  double amountPerContract = 0;
  prefix.OpenLimitOrderRequestModel order;
  OpenRewardRequestModel marketOrder;
  Commission commission;
  double actLevel = 0;
  Position usdtBalance;
  Contract saveContract;
  double savedAmount;
  List<Widget> couponList = [];
  List<custom.DropdownMenuItem<Coupon>> couponDropdownList;
  Coupon selectedCoupon;
  double couponTotalAmount;
  List<Coupon> couponListData = [];
  int couponAmount = 0;

  BBBAPI _api;
  MarketManager _mtm;
  RefManager _refm;
  UserManager _um;
  CouponViewModel _cm;

  StreamSubscription _lastTickerSub;

  CouponOrderViewModel(
      {@required BBBAPI api,
      @required MarketManager mtm,
      @required RefManager refm,
      @required UserManager um,
      @required CouponViewModel cm,
      this.orderForm}) {
    _api = api;
    _mtm = mtm;
    _refm = refm;
    _um = um;
    _cm = cm;
    isSatisfied = true;
    currentTicker = _mtm.lastTicker.value;
  }

  @override
  dispose() {
    _lastTickerSub.cancel();
    super.dispose();
  }

  initForm(bool isup, Coupon coupon) {
    orderForm = LimitOrderForm(
        isUp: isup,
        investAmount: 1,
        showCutoff: false,
        showProfit: false,
        totalAmount: Asset(amount: 0),
        cybBalance: Position(quantity: 0),
        fee: Asset(amount: 0));
    selectedCoupon = coupon;
    _lastTickerSub = _mtm.lastTicker.listen((onData) {
      buildPickerMenuItem(contractIds);
      updateAmountAndFee();
    });
  }

  Contract get contract => orderForm.selectedItem;

  List<Contract> get contractIds {
    if (orderForm.isUp) {
      return _refm.allUpContract.where((contract) {
        return (currentTicker.value > contract.strikeLevel) &&
            ((currentTicker.value / ((currentTicker.value - contract.strikeLevel).abs())) <=
                _refm.couponConfig.maxGearing);
      }).toList();
    } else {
      return _refm.allDownContract.where((contract) {
        return (currentTicker.value < contract.strikeLevel) &&
            ((currentTicker.value / ((currentTicker.value - contract.strikeLevel).abs())) <=
                _refm.couponConfig.maxGearing);
      }).toList();
    }
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
                      ? (currentTicker.value / (currentTicker.value - contract.strikeLevel))
                          .toStringAsFixed(1)
                      : (currentTicker.value / (contract.strikeLevel - currentTicker.value))
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
      setBusy(false);
    }
  }

  buildCouponDropdown() {
    if (_cm.pendingCoupon != null && _cm.pendingCoupon.isNotEmpty) {
      List<custom.DropdownMenuItem<Coupon>> items = List();
      for (Coupon coupon in _cm.pendingCoupon) {
        if (coupon.status == couponStatusMap[CouponStatus.activated] &&
            DateTime.parse(coupon.effDate).isBefore(DateTime.now())) {
          items.add(
            custom.DropdownMenuItem(
              value: coupon,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(coupon.amount.toStringAsFixed(0), style: StyleNewFactory.grey14),
              ),
            ),
          );
        }
      }
      couponDropdownList = items;
      selectedCoupon =
          selectedCoupon != null ? selectedCoupon : (items.isEmpty ? null : items[0].value);
    } else {
      couponDropdownList = null;
      selectedCoupon = null;
      orderForm.totalAmount.amount = 0;
    }
    setBusy(false);
  }

  buildCouponList() {
    couponList = [];
    couponListData = [];
    for (Coupon coupon in _cm.pendingCoupon) {
      if (coupon.status == couponStatusMap[CouponStatus.activated] &&
          DateTime.parse(coupon.effDate).isBefore(DateTime.now())) {
        couponList.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(coupon.amount.toStringAsFixed(0), style: StyleNewFactory.grey14),
            Text(dateFormat(date: coupon.expDate), style: StyleNewFactory.grey14),
          ],
        ));
        couponListData.add(coupon);
      }
    }
  }

  onChnageDropdownSelection(Contract selected) {
    orderForm.selectedItem = selected;
    changeCutLoss = true;
    updateCurrentContract(orderForm.isUp, orderForm.selectedItem.contractId);
  }

  onChnageCouponDropdownSelection(Coupon coupon) {
    if (coupon != null) {
      selectedCoupon = coupon;
    }
    setBusy(false);
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
        ? (ticker.value / (ticker.value - contract.strikeLevel))
        : (ticker.value / (contract.strikeLevel - ticker.value));
    amountPerContract =
        ((orderForm.isUp ? (ticker.value + 10) : (ticker.value - 10)) - contract.strikeLevel)
                .abs() *
            contract.conversionRate.abs();

    double commiDouble = orderForm.investAmount *
        ticker.value *
        contract.conversionRate.abs() *
        contract.commissionRate;

    orderForm.fee = Asset(amount: commiDouble);
    double totalAmount = orderForm.investAmount * amountPerContract;
    if (selectedCoupon != null) {
      couponAmount = selectedCoupon.amount ~/ totalAmount;
    }

    orderForm.totalAmount = Asset(amount: totalAmount + commiDouble);
    if (orderForm.investAmount > _refm.config.maxOrderQuantity ||
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

  fetchCouponBalance() async {
    await _cm.getCoupons();
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

  void saveMarketOrder() {
    ticker = _mtm.lastTicker.value;
    saveContract = orderForm.selectedItem;
    savedAmount = orderForm.totalAmount.amount;
    marketOrder = OpenRewardRequestModel(data: Data());
  }

  Future<PostOrderResponseModel> postMarketOrder() async {
    if (_um.user.testAccountResponseModel != null) {
      CybexFlutterPlugin.setDefaultPrivKey(_um.user.testAccountResponseModel.privkey);
    }
    int expir = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
    marketOrder.data.action = "coupon";
    marketOrder.data.user = _um.user.testAccountResponseModel != null
        ? _um.user.testAccountResponseModel.name
        : _um.user.account.name;
    marketOrder.data.contract = orderForm.selectedItem.contractId;
    marketOrder.data.takeProfitPrice =
        orderForm.takeProfitPx == null ? "0" : orderForm.takeProfitPx.toStringAsFixed(4);

    marketOrder.data.cutlossPrice = orderForm.cutoffPx == null
        ? orderForm.selectedItem.strikeLevel.toStringAsFixed(4)
        : orderForm.cutoffPx.toStringAsFixed(4);

    marketOrder.data.quantity = couponAmount;
    marketOrder.data.couponId = selectedCoupon.id;
    marketOrder.data.timeout = expir + 5 * 60;

    var data = marketOrder.data.toJson();
    String sig = await CybexFlutterPlugin.signMessageOperation(
        getQueryStringFromJson(data, data.keys.toList()..sort()));
    marketOrder.signature = sig.contains('\"') ? sig.substring(1, sig.length - 1) : sig;
    var orderRequest = marketOrder.toJson();
    print(orderRequest);
    PostOrderResponseModel result = await _api.postOrder(requestOrder: orderRequest);
    return result;
  }
}

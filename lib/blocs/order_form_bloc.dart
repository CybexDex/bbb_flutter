import 'dart:math';

import 'package:bbb_flutter/blocs/user_bloc.dart';
import 'package:bbb_flutter/models/form/order_form_model.dart';
import 'package:bbb_flutter/models/request/post_order_request_model.dart';
import 'package:bbb_flutter/models/response/post_order_response_model.dart';
import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
import 'package:bbb_flutter/models/response/web_socket_n_x_price_response_entity.dart';
import 'package:bbb_flutter/websocket/websocket_bloc.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:cybex_flutter_plugin/commision.dart';
import 'package:cybex_flutter_plugin/cybex_flutter_plugin.dart';
import 'package:cybex_flutter_plugin/order.dart';
import '../env.dart';
import 'package:rxdart/rxdart.dart';

class OrderFormBloc implements Bloc {
  BehaviorSubject<OrderForm> orderFormSubject =
      BehaviorSubject<OrderForm>(seedValue: OrderForm.test());
  BehaviorSubject<Contract> currentContract = BehaviorSubject<Contract>();
  BehaviorSubject<RefContractResponseModel> refDataSubject =
      BehaviorSubject<RefContractResponseModel>();

  String contractId;

  OrderFormBloc({this.contractId}) {
    WebSocketBloc().getNXPriceBloc.listen((data) {
      update();
    });
  }
  @override
  dispose() async {
    await orderFormSubject.close();
    await currentContract.close();
  }

  void setOrderForm(OrderForm form) {
    orderFormSubject.add(form);
  }

  void update() async {
    WebSocketNXPriceResponseEntity price = WebSocketBloc().getNXPriceBloc.value;
    RefContractResponseModel model = await Env.apiClient.getRefData();
    refDataSubject.add(model);

    var cContract =
        model.contract.where((c) => c.contractId == contractId).toList().first;
    if (cContract != null) {
      currentContract.add(cContract);
    }

    orderFormSubject.value.remaining =
        double.parse(currentContract.value.availableInventory);
    var amount = (price.px - double.parse(cContract.strikeLevel)) *
        double.parse(cContract.conversionRate);
    orderFormSubject.value.unitPrice =
        Asset(amount: amount, symbol: cContract.quoteAsset);

    double commiDouble = orderFormSubject.value.investAmount *
        price.px *
        double.parse(cContract.conversionRate) *
        double.parse(cContract.commissionRate);

    orderFormSubject.value.fee =
        Asset(amount: commiDouble, symbol: cContract.quoteAsset);
    double totalAmount = orderFormSubject.value.investAmount * amount;

    orderFormSubject.value.totalAmount =
        Asset(amount: totalAmount + commiDouble, symbol: cContract.quoteAsset);

    orderFormSubject.add(orderFormSubject.value);
  }

  void increaseInvest() {
    if (orderFormSubject.value.investAmount <
        orderFormSubject.value.remaining) {
      orderFormSubject.value.investAmount += 1;
      orderFormSubject.add(orderFormSubject.value);
      update();
    }
  }

  void decreaseInvest() {
    if (orderFormSubject.value.investAmount > 0) {
      orderFormSubject.value.investAmount -= 1;
      orderFormSubject.add(orderFormSubject.value);
      update();
    }
  }

  void increaseTakeProfit() {
    if (orderFormSubject.value.takeProfit < 100) {
      orderFormSubject.value.takeProfit += 10;
      orderFormSubject.add(orderFormSubject.value);
    }
  }

  void decreaseTakeProfit() {
    if (orderFormSubject.value.takeProfit > 10) {
      orderFormSubject.value.takeProfit -= 10;
      orderFormSubject.add(orderFormSubject.value);
    }
  }

  void increaseCutLoss() {
    if (orderFormSubject.value.cutoff < 100) {
      orderFormSubject.value.cutoff += 10;
      orderFormSubject.add(orderFormSubject.value);
    }
  }

  void decreaseCutLoss() {
    if (orderFormSubject.value.cutoff > 10) {
      orderFormSubject.value.cutoff -= 10;
      orderFormSubject.add(orderFormSubject.value);
    }
  }

  Future<PostOrderResponseModel> postOrder() async {
    WebSocketNXPriceResponseEntity price = WebSocketBloc().getNXPriceBloc.value;

    final refData = refDataSubject.value;
    final contract = currentContract.value;
    PostOrderRequestModel order = PostOrderRequestModel();
    Order buyOrder = getBuyOrder(refData, contract);
    Order sellOrder = getSellOrder(refData, contract);
    Commission commission = getCommission(refData, contract);

    order.buyOrder = buyOrder;
    order.sellOrder = sellOrder;
    order.commission = commission;

    order.underlyingSpotPx = price.px.toString();
    order.contractId = contractId;
    order.expiration =
        (DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000) + 24 * 60 * 60;

    order.buyOrder =
        await CybexFlutterPlugin.limitOrderCreateOperation(buyOrder);
    order.sellOrder =
        await CybexFlutterPlugin.limitOrderCreateOperation(sellOrder);
    order.commission = await CybexFlutterPlugin.transferOperation(commission);

    order.buyOrderTxId = order.buyOrder.transactionid;

    order.sellOrderTxId = order.sellOrder.transactionid;

    PostOrderResponseModel res = await Env.apiClient.postOrder(order: order);
    printWrapped(res.toRawJson());

    return Future.value(res);
  }

  Order getBuyOrder(RefContractResponseModel refData, Contract contract) {
    OrderForm form = orderFormSubject.value;
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
    order.fee = AmountToSell(amount: 55, assetId: "0");
    order.seller = UserBloc().userSubject.value.accountId;
    order.amountToSell = buyAmount;
    order.minToReceive =
        AmountToSell(amount: form.investAmount, assetId: baseAsset.assetId);
    order.fillOrKill = 1;
    order.txExpiration = expir + 5 * 60;
    order.expiration = expir + 5 * 60;
    return order;
  }

  Order getSellOrder(RefContractResponseModel refData, Contract contract) {
    OrderForm form = orderFormSubject.value;
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
    order.fee = AmountToSell(amount: 55, assetId: "0");
    order.seller = UserBloc().userSubject.value.accountId;
    order.amountToSell =
        AmountToSell(amount: form.investAmount, assetId: baseAsset.assetId);
    order.minToReceive =
        AmountToSell(amount: 1 * pow(10, 6), assetId: quoteAsset.assetId);
    order.fillOrKill = 1;
    order.txExpiration = expir + 365 * 24 * 60 * 60;
    order.expiration = int.parse(contract.tradingStopTime) + 60;
    return order;
  }

  Commission getCommission(
      RefContractResponseModel refData, Contract contract) {
    OrderForm form = orderFormSubject.value;
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
    comm.fee = AmountToSell(amount: 55, assetId: "0");
    comm.from = UserBloc().userSubject.value.accountId;
    comm.to = refData.refContractResponseModelOperator.accountId;
    comm.amount = AmountToSell(
        assetId: quoteAsset.assetId, amount: (form.fee.amount).toInt());

    return comm;
  }
}

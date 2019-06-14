import 'dart:math';

import 'package:bbb_flutter/env.dart';
import 'package:bbb_flutter/models/request/post_order_request_model.dart';
import 'package:bbb_flutter/models/response/post_order_response_model.dart';
import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api_provider.dart';
import 'package:cybex_flutter_plugin/commision.dart';
import 'package:cybex_flutter_plugin/order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cybex_flutter_plugin/cybex_flutter_plugin.dart';

AmountToSell cyb = AmountToSell(assetId: "0", amount: 55);
String user = "28828";
String account = "cybex-test";
String pwd = "cybextest123456";
String admin = "40691";
String contractId = "NBTC6200X070100";
AmountToSell usdt = AmountToSell(assetId: "723", amount: 1 * pow(10, 6));
AmountToSell nBTCAA = AmountToSell(assetId: "725", amount: 1000);
String btc = "8500";

void testOrder() async {
  // group("Order Post", () {
  RefContractResponseModel refData;
  Order buyOrder;
  Order sellOrder;
  Commission commission;

  PostOrderRequestModel order = PostOrderRequestModel();

  // setUp(() async {
  initLogger(package: 'bbb');
  Env.apiClient = BBBAPIProvider();

  refData = await getRefData();
  await CybexFlutterPlugin.getUserKeyWith(account, pwd);
  // });

  // tearDown(() {});

  // test("Construct Order", () {
  Contract contract = refData.contract.first;
  buyOrder = getBuyOrder(refData, contract);
  sellOrder = getSellOrder(refData, contract);
  commission = getCommission(refData, contract);

  order.buyOrder = buyOrder;
  order.sellOrder = sellOrder;
  order.commission = commission;
  order.underlyingSpotPx = btc;
  order.contractId = contractId;
  order.expiration =
      (DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000) + 24 * 60 * 60;
  // });

  // test("sign Order", () async {
  order.buyOrder = await CybexFlutterPlugin.limitOrderCreateOperation(buyOrder);
  order.sellOrder =
      await CybexFlutterPlugin.limitOrderCreateOperation(sellOrder);
  order.commission = await CybexFlutterPlugin.transferOperation(commission);

  order.buyOrderTxId = order.buyOrder.transactionid;

  order.sellOrderTxId = order.sellOrder.transactionid;
  // });

  // test("post Order", () async {
  printWrapped(order.toRawJson());
  PostOrderResponseModel res = await Env.apiClient.postOrder(order: order);
  // expect(res.status, "Successful");
  // });
  // });
}

Order getBuyOrder(RefContractResponseModel refData, Contract contract) {
  int expir = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
  AmountToSell buyAmount = AmountToSell.fromJson(usdt.toJson());
  double priceUnit = (double.parse(btc) - double.parse(contract.strikeLevel)) *
      double.parse(contract.conversionRate);
  buyAmount.amount = (nBTCAA.amount * priceUnit * usdt.amount).toInt();

  Order order = Order();
  order.chainid = refData.chainId;
  order.refBlockNum = refData.refBlockNum;
  order.refBlockPrefix = refData.refBlockPrefix;
  order.refBlockId = refData.refBlockId;
  order.fee = cyb;
  order.seller = user;
  order.amountToSell = buyAmount;
  order.minToReceive = nBTCAA;
  order.fillOrKill = 1;
  order.txExpiration = expir + 5 * 60;
  order.expiration = expir + 5 * 60;
  return order;
}

Order getSellOrder(RefContractResponseModel refData, Contract contract) {
  int expir = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
  Order order = Order();
  order.chainid = refData.chainId;
  order.refBlockNum = refData.refBlockNum;
  order.refBlockId = refData.refBlockId;
  order.refBlockPrefix = refData.refBlockPrefix;
  order.fee = cyb;
  order.seller = user;
  order.amountToSell = nBTCAA;
  order.minToReceive = usdt;
  order.fillOrKill = 1;
  order.txExpiration = expir + 365 * 24 * 60 * 60;
  order.expiration = int.parse(contract.tradingStopTime) + 60;
  return order;
}

Commission getCommission(RefContractResponseModel refData, Contract contract) {
  int expir = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
  double commiDouble = nBTCAA.amount *
      double.parse(btc) *
      double.parse(contract.conversionRate) *
      double.parse(contract.commissionRate);

  Commission comm = Commission();
  comm.chainid = refData.chainId;
  comm.refBlockNum = refData.refBlockNum;
  comm.refBlockPrefix = refData.refBlockPrefix;
  comm.refBlockId = refData.refBlockId;

  comm.txExpiration = expir + 5 * 60;
  comm.fee = cyb;
  comm.from = user;
  comm.to = admin;
  comm.amount = AmountToSell(
      assetId: usdt.assetId, amount: (commiDouble * usdt.amount).toInt());

  return comm;
}

Future<RefContractResponseModel> getRefData() async {
  RefContractResponseModel model = await Env.apiClient.getRefData();
  return Future.value(model);
}

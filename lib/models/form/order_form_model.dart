import 'package:bbb_flutter/models/response/positions_response_model.dart';

class OrderForm {
  int investAmount;
  double takeProfit;
  double cutoff;
  bool isUp;
  bool showProfit;
  bool showCutoff;
  Position cybBalance;

  Asset totalAmount;
  Asset fee;

  OrderForm(
      {this.investAmount,
      this.takeProfit,
      this.cutoff,
      this.isUp,
      this.fee,
      this.totalAmount,
      this.showCutoff,
      this.showProfit,
      this.cybBalance});
}

class Asset {
  double amount;
  String symbol;

  Asset({this.amount, this.symbol});
}

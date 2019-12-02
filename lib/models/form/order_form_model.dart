import 'package:bbb_flutter/models/response/positions_response_model.dart';

class OrderForm {
  int investAmount;
  double takeProfit;
  double cutoff;
  double takeProfitPx;
  double cutoffPx;
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
      this.takeProfitPx,
      this.cutoffPx,
      this.isUp,
      this.fee,
      this.totalAmount,
      this.showCutoff,
      this.showProfit,
      this.cybBalance});
}

class Asset {
  double amount = 0;
  String symbol;

  Asset({this.amount, this.symbol});
}

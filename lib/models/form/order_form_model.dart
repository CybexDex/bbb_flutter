class OrderForm {
  int investAmount;
  double takeProfit;
  double cutoff;
  bool isUp;
  bool showProfit;
  bool showCutoff;

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
      this.showProfit});
}

class Asset {
  double amount;
  String symbol;

  Asset({this.amount, this.symbol});
}

class OrderForm {
  int investAmount;
  double takeProfit;
  double cutoff;
  bool isUp;

  Asset totalAmount;
  Asset fee;

  OrderForm(
      {this.investAmount,
      this.takeProfit,
      this.cutoff,
      this.isUp,
      this.fee,
      this.totalAmount});
}

class Asset {
  double amount;
  String symbol;

  Asset({this.amount, this.symbol});
}

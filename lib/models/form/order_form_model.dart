class OrderForm {
  int investAmount;
  int takeProfit;
  int cutoff;
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

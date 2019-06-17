class OrderForm {
  Asset unitPrice;
  double remaining;
  int investAmount;
  int takeProfit;
  int cutoff;
  Asset takeProfitBenefit;
  Asset cutoffBenefit;
  Asset totalAmount;
  Asset fee;

  OrderForm(
      {this.unitPrice,
      this.remaining,
      this.investAmount,
      this.takeProfit,
      this.cutoff,
      this.takeProfitBenefit,
      this.cutoffBenefit,
      this.fee,
      this.totalAmount});

  factory OrderForm.test() {
    return OrderForm(
        remaining: 0,
        investAmount: 0,
        takeProfit: 50,
        cutoff: 50,
        unitPrice: Asset(amount: 0, symbol: "USDT"));
  }
}

class Asset {
  double amount;
  String symbol;

  Asset({this.amount, this.symbol});
}

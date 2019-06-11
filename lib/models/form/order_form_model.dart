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
}

class Asset {
  double amount;
  String symbol;
}

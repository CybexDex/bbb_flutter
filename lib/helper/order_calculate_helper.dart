class OrderCalculate {
  static double calculateRealTimeRevenue(
      {double currentPx,
      double orderBoughtPx,
      double conversionRate,
      double orderCommission,
      double orderQtyContract}) {
    var result =
        (currentPx - orderBoughtPx) * conversionRate * orderQtyContract -
            orderCommission;
    return result;
  }

  static double calculateRealLeverage(
      {double currentPx, double strikeLevel, bool isUp}) {
    if (isUp) {
      return (currentPx / (currentPx - strikeLevel));
    } else {
      return (currentPx / (strikeLevel - currentPx));
    }
  }

  static double calculateInvest(
      {double orderBoughtContractPx, double orderQtyContract}) {
    return (orderQtyContract * orderBoughtContractPx);
  }

  static double calculatePrice(
      double currentPx, double strikeLevel, double conversionRate) {
    return (currentPx - strikeLevel) * conversionRate;
  }
}

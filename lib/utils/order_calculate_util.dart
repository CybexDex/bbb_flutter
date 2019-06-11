class OrderCalculate {
  static String calculateRealTimeRevenue(
      {double currentPx,
      double orderBoughtPx,
      double conversionRate,
      double orderCommission,
      double orderQtyContract}) {
    var result =
        (currentPx - orderBoughtPx) * conversionRate * orderQtyContract -
            orderCommission;
    return result.toString();
  }

  static String calculateRealLeverage(
      {double currentPx, double strikeLevel, bool isUp}) {
    if (isUp) {
      return (currentPx / (currentPx - strikeLevel)).toString();
    } else {
      return (currentPx / (strikeLevel - currentPx)).toString();
    }
  }

  static String calculateInvest(
      {double orderBoughtContractPx, double orderQtyContract}) {
    return (orderQtyContract * orderBoughtContractPx).toString();
  }

  static double calculatePrice(double currentPx, double conversionRate) {
    return conversionRate * conversionRate;
  }
}

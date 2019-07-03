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

  static double takeProfitPx(
      double takeProfit, double currentPx, double strikeLevel, bool isUp) {
    if (isUp) {
      return currentPx + (currentPx - strikeLevel) * takeProfit / 100;
    } else {
      return currentPx - (strikeLevel - currentPx) * takeProfit / 100;
    }
  }

  static double getTakeProfit(double takeProfitPx, double underlayingPx,
      double strikeLevel, bool isUp) {
    if (isUp) {
      return (takeProfitPx - underlayingPx) *
          100 /
          (underlayingPx - strikeLevel);
    } else {
      return (underlayingPx - takeProfitPx) *
          100 /
          (strikeLevel - underlayingPx);
    }
  }

  static double cutLossPx(
      double cutLoss, double currentPx, double strikeLevel, bool isUp) {
    if (isUp) {
      return currentPx - (currentPx - strikeLevel) * cutLoss / 100;
    } else {
      return currentPx + (strikeLevel - currentPx) * cutLoss / 100;
    }
  }

  static double getCutLoss(
      double cutLossPx, double underlayingPx, double strikeLevel, bool isUp) {
    if (isUp) {
      return (underlayingPx - cutLossPx) * 100 / (underlayingPx - strikeLevel);
    } else {
      return (cutLossPx - underlayingPx) * 100 / (strikeLevel - underlayingPx);
    }
  }
}

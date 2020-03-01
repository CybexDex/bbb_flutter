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
    return (currentPx - strikeLevel) * conversionRate + 0.1;
  }

  static double calculateLimitOrderOpenPrice(bool isUp,
      double highestTriggerPrice, double lowestTriggerPrice, double strikePx) {
    return isUp
        ? ((highestTriggerPrice != 0
                ? highestTriggerPrice
                : lowestTriggerPrice) /
            ((highestTriggerPrice != 0
                    ? highestTriggerPrice
                    : lowestTriggerPrice) -
                strikePx))
        : ((highestTriggerPrice != 0
                ? highestTriggerPrice
                : lowestTriggerPrice) /
            (strikePx -
                (highestTriggerPrice != 0
                    ? highestTriggerPrice
                    : lowestTriggerPrice)));
  }

  static double takeProfitPx(
      double takeProfit, double basePx, double strikeLevel, bool isUp) {
    takeProfit = takeProfit.roundToDouble();
    if (isUp) {
      return basePx + (basePx - strikeLevel) * takeProfit / 100;
    } else {
      return basePx - (strikeLevel - basePx) * takeProfit / 100;
    }
  }

  static double getTakeProfit(
      double takeProfitPx, double boughtPx, double strikeLevel, bool isUp) {
    if (isUp) {
      return (takeProfitPx - boughtPx) * 100 / (boughtPx - strikeLevel);
    } else {
      return (boughtPx - takeProfitPx) * 100 / (strikeLevel - boughtPx);
    }
  }

  static double cutLossPx(
      double cutLoss, double basePx, double strikeLevel, bool isUp) {
    cutLoss = cutLoss.roundToDouble();
    if (isUp) {
      return basePx - (basePx - strikeLevel) * cutLoss / 100;
    } else {
      return basePx + (strikeLevel - basePx) * cutLoss / 100;
    }
  }

  static double getCutLoss(
      double cutLossPx, double boughtPx, double strikeLevel, bool isUp) {
    if (isUp) {
      return (boughtPx - cutLossPx) * 100 / (boughtPx - strikeLevel);
    } else {
      return (cutLossPx - boughtPx) * 100 / (strikeLevel - boughtPx);
    }
  }
}

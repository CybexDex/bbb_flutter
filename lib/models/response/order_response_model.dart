class OrderResponseModel {
  String commissionInUsd;
  String accountName;
  String takeProfitPx;
  String contract;
  String refBXBT;
  String buyAmountInUsd;
  String knockOutTime;
  String qtyContract;
  String settleAtBXBT;
  String createTime;
  String cutLossPx;
  String settleAmountInUsd;
  String buyAtBXBT;
  String execNowPx;
  int forceExpiration;
  String status;
  String buyOrderTxId;
  String lastUpdateTime;

  OrderResponseModel(
      {this.commissionInUsd,
      this.accountName,
      this.takeProfitPx,
      this.contract,
      this.refBXBT,
      this.buyAmountInUsd,
      this.knockOutTime,
      this.qtyContract,
      this.settleAtBXBT,
      this.createTime,
      this.cutLossPx,
      this.settleAmountInUsd,
      this.buyAtBXBT,
      this.execNowPx,
      this.forceExpiration,
      this.status,
      this.buyOrderTxId,
      this.lastUpdateTime});

  OrderResponseModel.fromJson(Map<String, dynamic> json) {
    commissionInUsd = json['commissionInUsd'];
    accountName = json['accountName'];
    takeProfitPx = json['takeProfitPx'];
    contract = json['contract'];
    refBXBT = json['refBXBT'];
    buyAmountInUsd = json['buyAmountInUsd'];
    knockOutTime = json['knockOutTime'];
    qtyContract = json['qtyContract'];
    settleAtBXBT = json['settleAtBXBT'];
    createTime = json['createTime'];
    cutLossPx = json['cutLossPx'];
    settleAmountInUsd = json['settleAmountInUsd'];
    buyAtBXBT = json['buyAtBXBT'];
    execNowPx = json['execNowPx'];
    forceExpiration = json['forceExpiration'];
    status = json['status'];
    buyOrderTxId = json['buyOrderTxId'];
    lastUpdateTime = json['lastUpdateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commissionInUsd'] = this.commissionInUsd;
    data['accountName'] = this.accountName;
    data['takeProfitPx'] = this.takeProfitPx;
    data['contract'] = this.contract;
    data['refBXBT'] = this.refBXBT;
    data['buyAmountInUsd'] = this.buyAmountInUsd;
    data['knockOutTime'] = this.knockOutTime;
    data['qtyContract'] = this.qtyContract;
    data['settleAtBXBT'] = this.settleAtBXBT;
    data['createTime'] = this.createTime;
    data['cutLossPx'] = this.cutLossPx;
    data['settleAmountInUsd'] = this.settleAmountInUsd;
    data['buyAtBXBT'] = this.buyAtBXBT;
    data['execNowPx'] = this.execNowPx;
    data['forceExpiration'] = this.forceExpiration;
    data['status'] = this.status;
    data['buyOrderTxId'] = this.buyOrderTxId;
    data['lastUpdateTime'] = this.lastUpdateTime;
    return data;
  }
}

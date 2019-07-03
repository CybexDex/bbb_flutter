import 'dart:convert';

class AmendOrderRequestModel {
  String transactionType;
  String seller;
  String refBuyOrderTxId;
  String signature;
  String takeProfitPx;
  String cutLossPx;
  String txId;
  String execNowPx;
  int expiration;

  AmendOrderRequestModel(
      {this.transactionType,
      this.seller,
      this.refBuyOrderTxId,
      this.signature,
      this.takeProfitPx,
      this.cutLossPx,
      this.txId,
      this.execNowPx,
      this.expiration});

  AmendOrderRequestModel.fromJson(Map<String, dynamic> json) {
    transactionType = json['transactionType'];
    seller = json['seller'];
    refBuyOrderTxId = json['refBuyOrderTxId'];
    signature = json['signature'];
    takeProfitPx = json['takeProfitPx'];
    cutLossPx = json['cutLossPx'];
    txId = json['txId'];
    execNowPx = json['execNowPx'];
    expiration = json['expiration'];
  }

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transactionType'] = this.transactionType;
    data['seller'] = this.seller;
    data['refBuyOrderTxId'] = this.refBuyOrderTxId;
    data['signature'] = this.signature;
    data['takeProfitPx'] = this.takeProfitPx;
    data['cutLossPx'] = this.cutLossPx;
    data['txId'] = this.txId;
    data['execNowPx'] = this.execNowPx;
    data['expiration'] = this.expiration;
    return data;
  }
}

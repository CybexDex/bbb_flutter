import 'dart:convert';

class AmendOrderRequestModel {
  String transactionType;
  String seller;
  String refBuyOrderTxId;
  String signature;
  String takeProfitPx;
  String cutLossPx;
  String execNowPx;
  int expiration;

  AmendOrderRequestModel(
      {this.transactionType,
      this.seller,
      this.refBuyOrderTxId,
      this.signature,
      this.takeProfitPx,
      this.cutLossPx,
      this.execNowPx,
      this.expiration});

  AmendOrderRequestModel.fromJson(Map<String, dynamic> json) {
    transactionType = json['transactionType'];
    seller = json['seller'];
    refBuyOrderTxId = json['refBuyOrderTxId'];
    signature = json['signature'];
    takeProfitPx = json['takeProfitPx'];
    cutLossPx = json['cutLossPx'];
    execNowPx = json['execNowPx'];
    expiration = json['expiration'];
  }

  String toStreamString() {
    StringBuffer buff = StringBuffer();
    buff.write(refBuyOrderTxId);
    buff.write(cutLossPx);
    buff.write(takeProfitPx);
    buff.write(execNowPx);
    buff.write(expiration);
    buff.write(seller);

    return buff.toString();
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
    data['execNowPx'] = this.execNowPx;
    data['expiration'] = this.expiration;
    return data;
  }
}

class PostOrderResponseModel {
  String status;
  String seller;
  int orderSequence;
  String rejectReason;
  String rejectCode;
  String signature;
  String txId;
  String txType;
  String time;
  String reason;
  String details;

  PostOrderResponseModel(
      {this.status,
      this.seller,
      this.orderSequence,
      this.rejectReason,
      this.rejectCode,
      this.signature,
      this.txId,
      this.txType,
      this.time,
      this.reason,
      this.details});

  PostOrderResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    seller = json['seller'];
    orderSequence = json['orderSequence'];
    rejectReason = json['rejectReason'];
    rejectCode = json['rejectCode'];
    signature = json['signature'];
    txId = json['txId'];
    txType = json['txType'];
    time = json['time'];
    reason = json['reason'];
    details = json['details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['seller'] = this.seller;
    data['orderSequence'] = this.orderSequence;
    data['rejectReason'] = this.rejectReason;
    data['rejectCode'] = this.rejectCode;
    data['signature'] = this.signature;
    data['txId'] = this.txId;
    data['txType'] = this.txType;
    data['time'] = this.time;
    data['reason'] = this.reason;
    data['details'] = this.details;
    return data;
  }
}

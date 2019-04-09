class RefData {
  String chainId;
  String refBlockId;

  RefData({this.chainId, this.refBlockId});

  RefData.fromJSON(Map<String, dynamic> json) {
    this.chainId = json['chainId'];
    this.refBlockId = json['refBlockId'];
  }
}
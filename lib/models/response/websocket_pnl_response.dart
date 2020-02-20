class WebSocketPNLResponse {
  String topic;
  double pnl;
  String accountName;
  String contract;

  WebSocketPNLResponse({this.pnl, this.accountName, this.topic, this.contract});

  WebSocketPNLResponse.fromJson(Map<String, dynamic> json) {
    topic = json['topic'];
    accountName = json['accountName'];
    pnl = json['pnl'];
    contract = json['contract'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['topic'] = this.topic;
    data['pnl'] = this.pnl;
    data['accountName'] = this.accountName;
    data['contract'] = this.contract;
    return data;
  }
}

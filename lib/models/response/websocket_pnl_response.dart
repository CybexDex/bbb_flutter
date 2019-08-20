class WebSocketPNLResponse {
  String topic;
  double pnl;
  String accountName;
  String time;

  WebSocketPNLResponse({this.time, this.pnl, this.accountName, this.topic});

  WebSocketPNLResponse.fromJson(Map<String, dynamic> json) {
    topic = json['topic'];
    accountName = json['accountName'];
    pnl = json['pnl'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['topic'] = this.topic;
    data['pnl'] = this.pnl;
    data['accountName'] = this.accountName;
    data['time'] = this.time;
    return data;
  }
}

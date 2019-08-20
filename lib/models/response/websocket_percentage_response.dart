class WebSocketPercentageResponse {
  String topic;
  double xPercentage;
  double nPercentage;
  String time;

  WebSocketPercentageResponse(
      {this.time, this.xPercentage, this.nPercentage, this.topic});

  WebSocketPercentageResponse.fromJson(Map<String, dynamic> json) {
    topic = json['topic'];
    xPercentage = json['xPercentage'];
    nPercentage = json['nPercentage'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['topic'] = this.topic;
    data['xPercentage'] = this.xPercentage;
    data['nPercentage'] = this.nPercentage;
    data['time'] = this.time;
    return data;
  }
}

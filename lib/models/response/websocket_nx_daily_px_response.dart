class WebSocketNXDailyPxResponse {
  String topic;
  double lastDayPx;
  double highPx;
  double lowPx;
  String time;

  WebSocketNXDailyPxResponse(
      {this.time, this.lastDayPx, this.highPx, this.topic, this.lowPx});

  WebSocketNXDailyPxResponse.fromJson(Map<String, dynamic> json) {
    topic = json['topic'];
    lastDayPx = json['last_day_px'];
    highPx = json['high_px'];
    lowPx = json['low_px'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['topic'] = this.topic;
    data['last_day_px'] = this.lastDayPx;
    data['high_px'] = this.highPx;
    data['low_px'] = this.lowPx;
    data['time'] = this.time;
    return data;
  }
}

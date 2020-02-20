class WebSocketNXDailyPxResponse {
  String topic;
  double lastDayPx;
  double highPx;
  double lowPx;

  WebSocketNXDailyPxResponse(
      {this.lastDayPx, this.highPx, this.topic, this.lowPx});

  WebSocketNXDailyPxResponse.fromJson(Map<String, dynamic> json) {
    topic = json['topic'];
    lastDayPx = json['last_day_px'];
    highPx = json['high_px'];
    lowPx = json['low_px'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['topic'] = this.topic;
    data['last_day_px'] = this.lastDayPx;
    data['high_px'] = this.highPx;
    data['low_px'] = this.lowPx;
    return data;
  }
}

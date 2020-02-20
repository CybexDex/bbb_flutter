class WebSocketNXPriceResponseEntity {
  String topic;
  String sym;
  double px;
  String time;

  WebSocketNXPriceResponseEntity({this.sym, this.px, this.time, this.topic});

  WebSocketNXPriceResponseEntity.fromJson(Map<String, dynamic> json) {
    sym = json['sym'];
    px = json['px'];
    time = json['time'];
    topic = json['topic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sym'] = this.sym;
    data['px'] = this.px;
    data['time'] = this.time;
    data['topic'] = this.topic;
    return data;
  }
}

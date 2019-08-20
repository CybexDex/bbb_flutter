class WebSocketNXPriceResponseEntity {
  String topic;
  String sym;
  int xts;
  double px;
  String time;

  WebSocketNXPriceResponseEntity(
      {this.sym, this.xts, this.px, this.time, this.topic});

  WebSocketNXPriceResponseEntity.fromJson(Map<String, dynamic> json) {
    sym = json['sym'];
    xts = json['xts'];
    px = json['px'];
    time = json['time'];
    topic = json['topic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sym'] = this.sym;
    data['xts'] = this.xts;
    data['px'] = this.px;
    data['time'] = this.time;
    data['topic'] = this.topic;
    return data;
  }
}

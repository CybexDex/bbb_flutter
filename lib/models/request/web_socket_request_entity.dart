class WebSocketRequestEntity {
  String topic;
  String type;

  WebSocketRequestEntity({this.topic, this.type});

  WebSocketRequestEntity.fromJson(Map<String, dynamic> json) {
    topic = json['topic'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['topic'] = this.topic;
    data['type'] = this.type;
    return data;
  }
}

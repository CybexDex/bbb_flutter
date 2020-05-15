class MarketHistoryResponseModel {
  String sym;
  int xts;
  double px;
  String time;

  MarketHistoryResponseModel({this.sym, this.xts, this.px, this.time});

  MarketHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    sym = json['sym'];
    xts = json['xts'];
    px = json['px'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sym'] = this.sym;
    data['xts'] = this.xts;
    data['px'] = this.px;
    data['time'] = this.time;
    return data;
  }
}

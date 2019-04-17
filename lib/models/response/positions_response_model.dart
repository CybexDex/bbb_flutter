class PositionsResponseModel {
  String accountName;
  List<PositionsResponsePosition> positions;
  String time;

  PositionsResponseModel({this.accountName, this.positions, this.time});

  PositionsResponseModel.fromJson(Map<String, dynamic> json) {
    accountName = json['accountName'];
    if (json['positions'] != null) {
      positions = new List<PositionsResponsePosition>();
      (json['positions'] as List).forEach((v) {
        positions.add(new PositionsResponsePosition.fromJson(v));
      });
    }
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accountName'] = this.accountName;
    if (this.positions != null) {
      data['positions'] = this.positions.map((v) => v.toJson()).toList();
    }
    data['time'] = this.time;
    return data;
  }
}

class PositionsResponsePosition {
  int quantity;
  String assetName;

  PositionsResponsePosition({this.quantity, this.assetName});

  PositionsResponsePosition.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];
    assetName = json['assetName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quantity'] = this.quantity;
    data['assetName'] = this.assetName;
    return data;
  }
}

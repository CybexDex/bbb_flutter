class FaucetCaptchaResponseModel {
  String data;
  String id;

  FaucetCaptchaResponseModel({this.data, this.id});

  FaucetCaptchaResponseModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['id'] = this.id;
    return data;
  }
}

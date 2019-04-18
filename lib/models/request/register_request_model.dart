class RegisterRequestModel {
  RegisterRequestCap cap;
  RegisterRequestAccount account;

  RegisterRequestModel({this.cap, this.account});

  RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    cap = json['cap'] != null
        ? new RegisterRequestCap.fromJson(json['cap'])
        : null;
    account = json['account'] != null
        ? new RegisterRequestAccount.fromJson(json['account'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cap != null) {
      data['cap'] = this.cap.toJson();
    }
    if (this.account != null) {
      data['account'] = this.account.toJson();
    }
    return data;
  }
}

class RegisterRequestCap {
  String captcha;
  String id;

  RegisterRequestCap({this.captcha, this.id});

  RegisterRequestCap.fromJson(Map<String, dynamic> json) {
    captcha = json['captcha'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['captcha'] = this.captcha;
    data['id'] = this.id;
    return data;
  }
}

class RegisterRequestAccount {
  String ownerKey;
  String referrer;
  String memoKey;
  String name;
  String refcode;
  String activeKey;

  RegisterRequestAccount(
      {this.ownerKey,
      this.referrer,
      this.memoKey,
      this.name,
      this.refcode,
      this.activeKey});

  RegisterRequestAccount.fromJson(Map<String, dynamic> json) {
    ownerKey = json['owner_key'];
    referrer = json['referrer'];
    memoKey = json['memo_key'];
    name = json['name'];
    refcode = json['refcode'];
    activeKey = json['active_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['owner_key'] = this.ownerKey;
    data['referrer'] = this.referrer;
    data['memo_key'] = this.memoKey;
    data['name'] = this.name;
    data['refcode'] = this.refcode;
    data['active_key'] = this.activeKey;
    return data;
  }
}

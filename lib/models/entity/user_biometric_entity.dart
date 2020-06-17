import 'dart:convert';

class UserBiometricEntity {
  String userName;
  bool isBiomtricOpen;
  int timeStamp;

  UserBiometricEntity({this.isBiomtricOpen, this.timeStamp, this.userName});

  factory UserBiometricEntity.fromRawJson(String str) =>
      UserBiometricEntity.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserBiometricEntity.fromJson(Map<String, dynamic> json) => UserBiometricEntity(
      userName: json["user_name"],
      isBiomtricOpen: json["is_biometric_open"],
      timeStamp: json["time_stamp"]);

  Map<String, dynamic> toJson() => {
        "user_name": userName,
        "is_biometric_open": isBiomtricOpen,
        "time_stamp": timeStamp,
      };
}

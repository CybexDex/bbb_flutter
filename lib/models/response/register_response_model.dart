import 'dart:convert';

class RegisterRequestResponse {
  int code;
  String error;

  RegisterRequestResponse({
    this.code,
    this.error,
  });

  factory RegisterRequestResponse.fromRawJson(String str) =>
      RegisterRequestResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RegisterRequestResponse.fromJson(Map<String, dynamic> json) =>
      new RegisterRequestResponse(
        code: json["code"],
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "error": error,
      };
}

import 'package:bbb_flutter/models/ref_data.dart';
import 'package:bbb_flutter/services/BBBAPI.dart';
import 'package:dio/dio.dart';

class BBBAPIProvider extends BBBAPI {
  factory BBBAPIProvider() =>_sharedInstance();

  static BBBAPIProvider _sharedInstance() {
    if (_instance == null) {
      _instance = BBBAPIProvider._();
    }
    return _instance;
  }

  static BBBAPIProvider _instance;

  Dio dio = Dio();

  BBBAPIProvider._() {
    dio.options.baseUrl = "https://nxapitest.cybex.io/v1";
    dio.options.connectTimeout = 5000; //5s
    dio.options.receiveTimeout = 3000;
  }

  @override
  Future<RefData> getRefData() async {
    var response = await dio.get('/refData');
    return RefData.fromJSON(response.data);
  }
}
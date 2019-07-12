import 'package:bbb_flutter/models/response/gateway_asset_response_model.dart';
import 'package:bbb_flutter/models/response/gateway_verifyaddress_response_model.dart';
import 'package:dio/dio.dart';

import 'getway_api.dart';

class GatewayAPIProvider extends GatewayApi {
  Dio dio = Dio();

  GatewayAPIProvider() {
    dio.options.baseUrl = "http://47.75.125.66:8182";
    dio.options.connectTimeout = 5000; //5s
    dio.options.receiveTimeout = 3000;
  }

  @override
  Future<GatewayAssetResponseModel> getAsset({String asset}) async {
    var response = await dio.get('/v1/assets/$asset');
    return Future.value(GatewayAssetResponseModel.fromJson(response.data));
  }

  @override
  Future<VerifyAddressResponseModel> verifyAddress(
      {String asset, String address}) async {
    var response = await dio.get('/v1/assets/$asset/address/$address/verify');
    return Future.value(VerifyAddressResponseModel.fromJson(response.data));
  }
}

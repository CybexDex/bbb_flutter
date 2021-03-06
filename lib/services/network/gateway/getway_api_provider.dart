import 'package:bbb_flutter/cache/shared_pref.dart';
import 'package:bbb_flutter/models/response/deposit_response_model.dart';
import 'package:bbb_flutter/models/response/gateway_asset_response_model.dart';
import 'package:bbb_flutter/models/response/gateway_verifyaddress_response_model.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:dio/dio.dart';

import 'getway_api.dart';

class GatewayAPIProvider extends GatewayApi {
  Dio dio = Dio();
  SharedPref _pref;

  GatewayAPIProvider({SharedPref sharedPref}) {
    _pref = sharedPref;
    _dispatchNode();
    dio.options.connectTimeout = 15000; //5s
    dio.options.receiveTimeout = 13000;
  }

  @override
  Future<GatewayAssetResponseModel> getAsset({String asset}) async {
    try {
      var response = await dio.get('/v1/assets/$asset');
      return Future.value(GatewayAssetResponseModel.fromJson(response.data));
    } on DioError catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Future<VerifyAddressResponseModel> verifyAddress(
      {String asset, String address}) async {
    var response = await dio.get('/v1/assets/$asset/address/$address/verify');
    return Future.value(VerifyAddressResponseModel.fromJson(response.data));
  }

  @override
  Future<DepositResponseModel> getDepositAddress(
      {String user, String asset, String authorization}) async {
    Map<String, dynamic> header = {
      "Content-Type": "application/json",
      "Authorization": authorization
    };
    var response = await dio.get("/v1/users/$user/assets/$asset/address",
        options: Options(headers: header));
    return Future.value(DepositResponseModel.fromJson(response.data));
  }

  @override
  setEnvMode({EnvType envType}) async {
    await _pref.saveEnvType(envType: envType);
    _dispatchNode();
  }

  _dispatchNode() {
    if (_pref.getEnvType() == EnvType.Pro) {
      dio.options.baseUrl = GatewayConnection.PRO_GATEWAY;
    } else if (_pref.getEnvType() == EnvType.Test) {
      dio.options.baseUrl = GatewayConnection.UAT_GATEWAY;
    } else {
      dio.options.baseUrl = GatewayConnection.PRO_GATEWAY;
    }
  }
}

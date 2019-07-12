import 'package:bbb_flutter/models/response/gateway_asset_response_model.dart';
import 'package:bbb_flutter/models/response/gateway_verifyaddress_response_model.dart';

abstract class GatewayApi {
  Future<GatewayAssetResponseModel> getAsset({String asset});
  Future<VerifyAddressResponseModel> verifyAddress(
      {String asset, String address});
//post
}

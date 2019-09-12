import 'package:bbb_flutter/models/response/update_response.dart';
import 'package:bbb_flutter/shared/types.dart';

abstract class ConfigureApi {
  UpdateResponse updateResponse;

  setEnvMode({EnvType envType});
  Future<UpdateResponse> getUpdateInfo({bool isIOS});
}

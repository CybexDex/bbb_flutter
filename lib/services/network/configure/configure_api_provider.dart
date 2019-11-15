import 'package:bbb_flutter/cache/shared_pref.dart';
import 'package:bbb_flutter/models/response/account_banner_response_model.dart';
import 'package:bbb_flutter/models/response/activities_response.dart';
import 'package:bbb_flutter/models/response/update_response.dart';
import 'package:bbb_flutter/services/network/configure/configure_api.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:dio/dio.dart';

import '../../../setup.dart';

class ConfiguireApiProvider extends ConfigureApi {
  Dio dio = Dio();
  SharedPref _pref;

  ConfiguireApiProvider({SharedPref sharedPref}) {
    _pref = sharedPref;
    _dispatchNode();
    dio.options.connectTimeout = 15000;
    dio.options.receiveTimeout = 13000;
    setupProxy(dio);
  }

  @override
  setEnvMode({EnvType envType}) async {
    await _pref.saveEnvType(envType: envType);
    _dispatchNode();
  }

  _dispatchNode() {
    dio.options.baseUrl = _pref.getEnvType() == EnvType.Pro
        ? ConfigureConnection.PRO_CONFIGURE
        : ConfigureConnection.UAT_CONFIGURE;
  }

  @override
  Future<UpdateResponse> getUpdateInfo({bool isIOS}) async {
    var response = await dio
        .get(isIOS ? "/BBB_IOS_store_update.json" : "/BBB_Android_update.json");
    updateResponse = UpdateResponse.fromJson(response.data);
    return Future.value(UpdateResponse.fromJson(response.data));
  }

  @override
  Future<List<ActivitiesResponse>> getActivities() async {
    var response = await dio.get("/json/bbb_activities.json");
    var responseData = response.data as List;
    if (responseData == null) {
      return Future.value([]);
    }
    activitiesResponseList =
        responseData.map((data) => ActivitiesResponse.fromJson(data)).toList();
    return Future.value(activitiesResponseList);
  }

  @override
  Future<List<BannerResponse>> getBanner() async {
    var response = await dio.get("/json/bbb_banners.json");
    var responseData = response.data as List;
    if (responseData == null) {
      return Future.value([]);
    }
    bannersResponseList =
        responseData.map((data) => BannerResponse.fromJson(data)).toList();
    return Future.value(bannersResponseList);
  }
}

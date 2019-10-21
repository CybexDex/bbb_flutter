import 'package:bbb_flutter/models/response/account_banner_response_model.dart';
import 'package:bbb_flutter/models/response/activities_response.dart';
import 'package:bbb_flutter/models/response/update_response.dart';
import 'package:bbb_flutter/shared/types.dart';

abstract class ConfigureApi {
  UpdateResponse updateResponse;
  List<ActivitiesResponse> activitiesResponseList;
  List<BannerResponse> bannersResponseList = [];

  setEnvMode({EnvType envType});
  Future<UpdateResponse> getUpdateInfo({bool isIOS});
  Future<List<ActivitiesResponse>> getActivities();
  Future<List<BannerResponse>> getBanner();
}

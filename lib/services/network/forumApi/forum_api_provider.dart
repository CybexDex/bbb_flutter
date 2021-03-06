import 'dart:convert';

import 'package:bbb_flutter/cache/shared_pref.dart';
import 'package:bbb_flutter/models/response/account_banner_response_model.dart';
import 'package:bbb_flutter/models/response/forum_response/assets_list.dart';
import 'package:bbb_flutter/models/response/forum_response/astrology_result.dart';
import 'package:bbb_flutter/models/response/forum_response/astroloty_predict.dart';
import 'package:bbb_flutter/models/response/forum_response/bolockchain_vip_result.dart';
import 'package:bbb_flutter/models/response/forum_response/forum_response.dart';
import 'package:bbb_flutter/models/response/forum_response/image_config.dart';
import 'package:bbb_flutter/models/response/forum_response/news_result.dart';
import 'package:bbb_flutter/models/response/forum_response/share_image_response.dart';
import 'package:bbb_flutter/models/response/forum_response/url_config_response.dart';
import 'package:bbb_flutter/screen/forum/astrology_header_result.dart';
import 'package:bbb_flutter/services/network/forumApi/forum_api.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:dio/dio.dart';

class ForumApiProvider extends ForumApi {
  Dio dio = Dio();
  SharedPref _pref;

  ForumApiProvider({SharedPref sharedPref}) {
    _pref = sharedPref;
    _dispatchNode();
    dio.options.connectTimeout = 15000; //5s
    dio.options.receiveTimeout = 13000;
    dio.options.headers = {'Connection': 'keep-alive'};
    dio.interceptors
        .add(LogInterceptor(request: false, requestBody: false, responseBody: false, error: true));
  }

  _dispatchNode() {
    if (_pref.getEnvType() == EnvType.Pro) {
      dio.options.baseUrl = ForumConnection.PRO_NODE;
    } else if (_pref.getEnvType() == EnvType.Test) {
      dio.options.baseUrl = ForumConnection.UAT_NODE;
    } else {
      dio.options.baseUrl = ForumConnection.PRO_NODE;
    }
  }

  @override
  setEnvMode({EnvType envType}) async {
    await _pref.saveEnvType(envType: envType);
    _dispatchNode();
  }

  @override
  Future<ForumResponse<NewsResult>> getNews({int pg, int siz}) async {
    var response = await dio.get("/list/prod/express/content", queryParameters: {
      "pg": pg,
      "siz": siz,
    });
    var responseData = json.decode(response.data);
    return Future.value(ForumResponse.fromJson(responseData));
  }

  @override
  Future<ForumResponse<AstrologyResult>> getAstrologyList({int pg, int siz}) async {
    var response =
        await dio.get("/list/prod/astrology/content", queryParameters: {"pg": pg, "siz": siz});
    var responseData = json.decode(response.data);
    return Future.value(ForumResponse.fromJson(responseData));
  }

  @override
  Future<ForumResponse<BlockchainVip>> getBlockchainVip({int pg, int siz}) async {
    var response =
        await dio.get("/list/prod/bigsister/content", queryParameters: {"pg": pg, "siz": siz});
    var responseData = json.decode(response.data);
    return Future.value(ForumResponse.fromJson(responseData));
  }

  @override
  Future<ForumResponse<BannerResponse>> getBanners({int pg, int siz}) async {
    var response = await dio.get("/list/prod/bbb/banner", queryParameters: {"pg": pg, "siz": siz});
    // var response = await rootBundle.loadString('test/config.json');
    var responseData = json.decode(response.data);
    return Future.value(ForumResponse.fromJson(responseData));
  }

  @override
  Future<ForumResponse<AssetList>> getAssetList({int pg, int siz}) async {
    var response = await dio.get("/list/prod/bbb/assets", queryParameters: {"pg": pg, "siz": siz});
    var responseData = json.decode(response.data);
    return Future.value(ForumResponse.fromJson(responseData));
  }

  @override
  Future<ForumResponse<UrlConfigResponse>> getUrlConfig({int pg, int siz}) async {
    var response = await dio.get("/list/prod/bbb/url", queryParameters: {"pg": pg, "siz": siz});
    var responseData = json.decode(response.data);
    return Future.value(ForumResponse.fromJson(responseData));
  }

  @override
  Future<AstrologyHeaderResult> getAstrologyHeader() async {
    var response = await dio.get("/item/prod/astrology/header");
    var responseData = json.decode(response.data);
    return Future.value(AstrologyHeaderResult.fromJson(responseData));
  }

  @override
  Future<AstrologyPredictResponse> getAstrologyPredict() async {
    var response = await dio.get("/item/prod/bbb/astrology");
    var responseData = json.decode(response.data);
    return Future.value(AstrologyPredictResponse.fromJson(responseData));
  }

  @override
  Future<ImageConfigResponse> getImageConfig({String version}) async {
    var response = await dio.get("/item/prod/bbb/ver$version");
    var responseData = json.decode(response.data);
    return Future.value(ImageConfigResponse.fromJson(responseData));
  }

  @override
  Future<ForumResponse<ShareImageResponse>> getSharedImages({int pg, int siz}) async {
    var response =
        await dio.get("/list/prod/bbb/refer_poster", queryParameters: {"pg": pg, "siz": siz});
    var responseData = json.decode(response.data);
    return Future.value(ForumResponse.fromJson(responseData));
  }
}

import 'package:bbb_flutter/models/response/account_banner_response_model.dart';
import 'package:bbb_flutter/models/response/forum_response/assets_list.dart';
import 'package:bbb_flutter/models/response/forum_response/astrology_result.dart';
import 'package:bbb_flutter/models/response/forum_response/astroloty_predict.dart';
import 'package:bbb_flutter/models/response/forum_response/bolockchain_vip_result.dart';
import 'package:bbb_flutter/models/response/forum_response/forum_response.dart';
import 'package:bbb_flutter/models/response/forum_response/news_result.dart';
import 'package:bbb_flutter/screen/forum/astrology_header_result.dart';
import 'package:bbb_flutter/shared/types.dart';

abstract class ForumApi {
  setEnvMode({EnvType envType});

  Future<ForumResponse<NewsResult>> getNews({int pg, int siz});
  Future<ForumResponse<AstrologyResult>> getAstrologyList({int pg, int siz});
  Future<ForumResponse<BlockchainVip>> getBlockchainVip({int pg, int siz});
  Future<AstrologyHeaderResult> getAstrologyHeader();
  Future<AstrologyPredictResponse> getAstrologyPredict();
  Future<ForumResponse<BannerResponse>> getBanners({int pg, int siz});
  Future<ForumResponse<AssetList>> getAssetList({int pg, int siz});
}

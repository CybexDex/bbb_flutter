import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/manager/timer_manager.dart';
import 'package:bbb_flutter/models/response/account_banner_response_model.dart';
import 'package:bbb_flutter/models/response/forum_response/astroloty_predict.dart';
import 'package:bbb_flutter/models/response/forum_response/forum_response.dart';
import 'package:bbb_flutter/models/response/ranking_response_model.dart';
import 'package:bbb_flutter/models/response/zendesk_advertise_reponse_model.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api.dart';
import 'package:bbb_flutter/services/network/configure/configure_api.dart';
import 'package:bbb_flutter/services/network/forumApi/forum_api.dart';
import 'package:bbb_flutter/services/network/zendesk/zendesk_api.dart';

import '../../setup.dart';

class HomeViewModel extends BaseModel {
  BBBAPI _bbbapi;
  ConfigureApi _configureApi;
  ForumApi _forumApi;
  ZendeskApi _zendeskApi;
  List<BannerResponse> banners = [];
  List<RankingResponse> rankingsPerorder = [];
  List<RankingResponse> rankingsTotal = [];
  List<Articles> zendeskAdvertise = [];
  AstrologyPredictResponse astrologyPredictResponse;

  HomeViewModel(
      {BBBAPI bbbapi,
      ConfigureApi configureApi,
      ForumApi forumApi,
      ZendeskApi zendeskApi}) {
    _bbbapi = bbbapi;
    _configureApi = configureApi;
    _forumApi = forumApi;
    _zendeskApi = zendeskApi;
  }

  getBanners() async {
    ForumResponse<BannerResponse> response =
        await _forumApi.getBanners(pg: 0, siz: 100);
    banners = response.result;
    setBusy(false);
  }

  getRankingList() async {
    rankingsPerorder = await _bbbapi.getRankings(indicator: 0);
    rankingsTotal = await _bbbapi.getRankings(indicator: 1);
    setBusy(false);
  }

  getZendeskAdvertise() async {
    var zendeskAdvertiseResponse =
        await _zendeskApi.getZendeskAdvertise(count: 6, sortBy: "created_at");
    zendeskAdvertise = zendeskAdvertiseResponse.articles;
    setBusy(false);
  }

  getAstrologyPredict() async {
    astrologyPredictResponse = await _forumApi.getAstrologyPredict();
    setBusy(false);
  }

  startLoop() {
    var timerManager = locator.get<TimerManager>();
    timerManager.rankingUpdate.listen((_) {
      getRankingList();
    });
    print("cc");
    timerManager.rankingUpdateStart();
  }
}

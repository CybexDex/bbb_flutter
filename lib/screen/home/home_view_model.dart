import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/helper/utils.dart';
import 'package:bbb_flutter/manager/timer_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/account_banner_response_model.dart';
import 'package:bbb_flutter/models/response/forum_response/forum_response.dart';
import 'package:bbb_flutter/models/response/forum_response/image_config.dart';
import 'package:bbb_flutter/models/response/forum_response/share_image_response.dart';
import 'package:bbb_flutter/models/response/gateway_asset_response_model.dart';
import 'package:bbb_flutter/models/response/ranking_response_model.dart';
import 'package:bbb_flutter/models/response/zendesk_advertise_reponse_model.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api.dart';
import 'package:bbb_flutter/services/network/configure/configure_api.dart';
import 'package:bbb_flutter/services/network/forumApi/forum_api.dart';
import 'package:bbb_flutter/services/network/gateway/getway_api.dart';
import 'package:bbb_flutter/services/network/zendesk/zendesk_api.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:package_info/package_info.dart';

import '../../setup.dart';

class HomeViewModel extends BaseModel {
  BBBAPI _bbbapi;
  ForumApi _forumApi;
  ZendeskApi _zendeskApi;
  GatewayApi _gatewayApi;
  List<BannerResponse> banners = [];
  List<RankingResponse> rankingsPerorder = [];
  List<RankingResponse> rankingsTotal = [];
  List<Articles> zendeskAdvertise = [];
  ImageConfigResponse imageConfigResponse;
  List<ShareImageResponse> shareImageList = [];
  bool depositAvailable = true;
  bool isAutoPlay = false;

  HomeViewModel(
      {BBBAPI bbbapi,
      ConfigureApi configureApi,
      ForumApi forumApi,
      ZendeskApi zendeskApi,
      GatewayApi gatewayApi,
      UserManager userManager}) {
    _bbbapi = bbbapi;
    _forumApi = forumApi;
    _zendeskApi = zendeskApi;
    _gatewayApi = gatewayApi;
  }

  getGatewayInfo({String assetName}) async {
    try {
      GatewayAssetResponseModel gatewayAssetResponseModel =
          await _gatewayApi.getAsset(asset: assetName);
      if (gatewayAssetResponseModel != null) {
        depositAvailable = gatewayAssetResponseModel.depositSwitch;
        setBusy(false);
      }
    } catch (err) {
      depositAvailable = false;
      setBusy(false);
    }
  }

  Future<ForumResponse<BannerResponse>> getBanners() async {
    ForumResponse<BannerResponse> response = await _forumApi.getBanners(pg: 0, siz: 100);
    banners = response.result;
    return response;
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

  getImageConfig() async {
    imageConfigResponse = await _forumApi.getImageConfig(
        version: locator.get<PackageInfo>().version.replaceAll(".", "-"));
    setBusy(false);
  }

  getSharedImage() async {
    var response = await _forumApi.getSharedImages(pg: 0, siz: 100);
    shareImageList = response.result;
  }

  startLoop() {
    var timerManager = locator.get<TimerManager>();
    timerManager.rankingUpdate.listen((_) {
      getRankingList();
    });
    timerManager.rankingUpdateStart();
  }

  checkDeposit(BuildContext context) {
    jumpToUrl(
        Uri.encodeFull("${imageConfigResponse?.result?.midBannerLink2 ?? GuessUpDownUrl.URL}"),
        context,
        needLogIn: imageConfigResponse?.result?.midBannerNeedName2 == "1");
  }

  checkGuess(BuildContext context) {
    jumpToUrl(
        Uri.encodeFull("${imageConfigResponse?.result?.midBannerLink1 ?? GuessUpDownUrl.URL}"),
        context,
        needLogIn: imageConfigResponse?.result?.midBannerNeedName1 == "1");
  }
}

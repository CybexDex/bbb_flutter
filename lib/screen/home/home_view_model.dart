import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/manager/timer_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/account_banner_response_model.dart';
import 'package:bbb_flutter/models/response/forum_response/astroloty_predict.dart';
import 'package:bbb_flutter/models/response/forum_response/forum_response.dart';
import 'package:bbb_flutter/models/response/gateway_asset_response_model.dart';
import 'package:bbb_flutter/models/response/ranking_response_model.dart';
import 'package:bbb_flutter/models/response/zendesk_advertise_reponse_model.dart';
import 'package:bbb_flutter/routes/routes.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api.dart';
import 'package:bbb_flutter/services/network/configure/configure_api.dart';
import 'package:bbb_flutter/services/network/forumApi/forum_api.dart';
import 'package:bbb_flutter/services/network/gateway/getway_api.dart';
import 'package:bbb_flutter/services/network/zendesk/zendesk_api.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:oktoast/oktoast.dart';

import '../../setup.dart';

class HomeViewModel extends BaseModel {
  BBBAPI _bbbapi;
  ConfigureApi _configureApi;
  ForumApi _forumApi;
  ZendeskApi _zendeskApi;
  GatewayApi _gatewayApi;
  UserManager _userManager;
  List<BannerResponse> banners = [];
  List<RankingResponse> rankingsPerorder = [];
  List<RankingResponse> rankingsTotal = [];
  List<Articles> zendeskAdvertise = [];
  AstrologyPredictResponse astrologyPredictResponse;
  bool depositAvailable = true;

  HomeViewModel(
      {BBBAPI bbbapi,
      ConfigureApi configureApi,
      ForumApi forumApi,
      ZendeskApi zendeskApi,
      GatewayApi gatewayApi,
      UserManager userManager}) {
    _bbbapi = bbbapi;
    _configureApi = configureApi;
    _forumApi = forumApi;
    _zendeskApi = zendeskApi;
    _gatewayApi = gatewayApi;
    _userManager = userManager;
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
    timerManager.rankingUpdateStart();
  }

  checkDeposit(BuildContext context) {
    if (depositAvailable) {
      if (_userManager.user.logined) {
        if (_userManager.user.testAccountResponseModel != null) {
          showToast(I18n.of(context).toastFormalAccount,
              textPadding: EdgeInsets.all(20));
        } else {
          Navigator.of(context).pushNamed(RoutePaths.Deposit);
        }
      } else {
        Navigator.of(context).pushNamed(RoutePaths.Login);
      }
    } else {
      showToast(I18n.of(context).toastDeposit, textPadding: EdgeInsets.all(20));
    }
  }

  checkGuess(BuildContext context) {
    if (_userManager.user.logined) {
      if (_userManager.user.testAccountResponseModel != null) {
        showToast(I18n.of(context).toastFormalAccount,
            textPadding: EdgeInsets.all(20));
      } else {
        launchURL(
            url: Uri.encodeFull(
                "${GuessUpDownUrl.URL}${_userManager.user.name}"));
      }
    } else {
      Navigator.of(context).pushNamed(RoutePaths.Login);
    }
  }
}

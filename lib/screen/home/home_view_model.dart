import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/cache/shared_pref.dart';
import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/helper/utils.dart';
import 'package:bbb_flutter/logic/nav_drawer_vm.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/manager/timer_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/entity/user_biometric_entity.dart';
import 'package:bbb_flutter/models/response/account_banner_response_model.dart';
import 'package:bbb_flutter/models/response/forum_response/forum_response.dart';
import 'package:bbb_flutter/models/response/forum_response/image_config.dart';
import 'package:bbb_flutter/models/response/forum_response/share_image_response.dart';
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
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:oktoast/oktoast.dart';
import 'package:package_info/package_info.dart';

import '../../setup.dart';

class HomeViewModel extends BaseModel {
  BBBAPI _bbbapi;
  ForumApi _forumApi;
  ZendeskApi _zendeskApi;
  GatewayApi _gatewayApi;
  UserManager _userManager;
  RefManager _refManager;
  List<BannerResponse> banners = [];
  List<RankingResponse> rankingsPerorder = [];
  List<RankingResponse> rankingsTotal = [];
  List<Articles> zendeskAdvertise = [];
  ImageConfigResponse imageConfigResponse;
  List<ShareImageResponse> shareImageList = [];
  bool depositAvailable = true;
  bool isAutoPlay = false;
  bool shouldShowCompetition = false;

  HomeViewModel(
      {BBBAPI bbbapi,
      ConfigureApi configureApi,
      ForumApi forumApi,
      ZendeskApi zendeskApi,
      GatewayApi gatewayApi,
      UserManager userManager,
      RefManager refManager}) {
    _bbbapi = bbbapi;
    _forumApi = forumApi;
    _zendeskApi = zendeskApi;
    _gatewayApi = gatewayApi;
    _userManager = userManager;
    _refManager = refManager;
  }

  checkIfShowCompetition() {
    if (_refManager?.action?.isActive == 1) {
      shouldShowCompetition = true;
    }
    _userManager.checkCompetitionQualification();
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
    if (shouldShowCompetition) {
      if (_userManager.user.loginType == LoginType.test) {
        showToast(I18n.of(context).toastFormalAccount, textPadding: EdgeInsets.all(20));
      } else {
        if (!_userManager.user.logined) {
          Navigator.pushNamed(context, RoutePaths.Login);
        } else {
          if (_userManager.hasCompetition) {
            _userManager.loginReward(action: _refManager.action.name);
            showFlashBar(context, false,
                content: I18n.of(globalKey.currentContext).changeToReward, callback: () {});
            locator.get<NavDrawerViewModel>().onChangeAsset(context: context, asset: "BTC");
          } else {
            showToast("暂无参赛资格", textPadding: EdgeInsets.all(20));
          }
        }
      }
    } else {
      jumpToUrl(
          Uri.encodeFull("${imageConfigResponse?.result?.midBannerLink2 ?? GuessUpDownUrl.URL}"),
          context,
          needLogIn: imageConfigResponse?.result?.midBannerNeedName2 == "1");
    }
  }

  checkGuess(BuildContext context) {
    jumpToUrl(
        Uri.encodeFull("${imageConfigResponse?.result?.midBannerLink1 ?? GuessUpDownUrl.URL}"),
        context,
        needLogIn: imageConfigResponse?.result?.midBannerNeedName1 == "1");
  }

  checkIfBiometricExpired(BuildContext context) {
    TextEditingController controller = TextEditingController();
    UserBiometricEntity userBiometricEntity =
        locator.get<SharedPref>().getUserBiometricEntity(userName: _userManager.user.name);
    if (userBiometricEntity.isBiomtricOpen) {
      checkIfShowReminderDialog(userBiometricEntity, context, controller);
    }
  }

  @override
  void dispose() {
    return;
  }
}

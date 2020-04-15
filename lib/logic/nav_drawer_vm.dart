import 'dart:async';

import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/manager/market_manager.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/bbb_query_response/ticker_response.dart';
import 'package:bbb_flutter/models/response/bbb_query_response/underlying_asset_response.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api.dart';
import 'package:bbb_flutter/shared/ui_common.dart';

class NavDrawerViewModel extends BaseModel {
  BBBAPI _bbbapi;
  RefManager _refManager;
  UserManager _userManager;
  MarketManager _marketManager;
  List<UnderlyingAssetResponse> assetList = [];
  List<TickerResponse> tickerList = [];

  StreamSubscription _refSub;

  NavDrawerViewModel(
      {BBBAPI bbbapi,
      RefManager refManager,
      UserManager userManager,
      MarketManager marketManager}) {
    _bbbapi = bbbapi;
    _refManager = refManager;
    _userManager = userManager;
    _marketManager = marketManager;
  }

  getAssetList() async {
    List<UnderlyingAssetResponse> response = await _bbbapi.getAsset();
    assetList = response;
    setBusy(false);
  }

  getTickers() async {
    if (assetList.isNotEmpty) {
      for (int i = 0; i < assetList.length; i++) {
        TickerResponse response = await _bbbapi.getTicker(injectAsset: assetList[i].underlying);
        if (tickerList.length < assetList.length) {
          tickerList.add(response);
        } else {
          tickerList[i].latest = response.latest;
          tickerList[i].lastDayPx = response.lastDayPx;
        }
      }
    }
    setBusy(false);
  }

  subscribeTicker() {
    _refSub = _refManager.contractController.listen((data) => getTickers());
  }

  unsubscribeTicker() {
    _refSub.cancel();
  }

  onChangeAsset({BuildContext context, String asset}) async {
    await _bbbapi.setAsset(asset: asset);
    _refManager.getConfig();
    _bbbapi.getRankings(indicator: 0);
    _bbbapi.getRankings(indicator: 1);
    _marketManager.cleanData();
    await _userManager.reload();
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _refSub.cancel();
    super.dispose();
  }
}

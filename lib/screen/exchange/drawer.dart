import 'package:badges/badges.dart';
import 'package:bbb_flutter/helper/decimal_util.dart';
import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/account_banner_response_model.dart';
import 'package:bbb_flutter/models/response/positions_response_model.dart';
import 'package:bbb_flutter/routes/routes.dart';
import 'package:bbb_flutter/services/network/configure/configure_api.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/speech_bubble.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:package_info/package_info.dart';

class UserDrawer extends StatefulWidget {
  const UserDrawer({Key key}) : super(key: key);

  @override
  _UserDrawerState createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  @override
  void initState() {
    if (locator.get<UserManager>().user.testAccountResponseModel == null) {
      locator.get<UserManager>().getGatewayInfo(assetName: AssetName.USDTERC20);
      locator
          .get<UserManager>()
          .checkRewardAccount(accountName: locator.get<UserManager>().user.name, bonusEvent: true);
    }
    locator.get<ConfigureApi>().getBanner();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the Drawer if there isn't enough vertical
      // space to fit everything.
      child: Consumer<UserManager>(builder: (context, userMg, child) {
        Position usdt = userMg.fetchPositionFrom(AssetName.NXUSDT);
        return Container(
          color: Colors.white,
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                color: Palette.drawerBackgroundColor,
                padding: EdgeInsets.fromLTRB(16.0, 46.0, 16.0, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Align(
                          child: GestureDetector(
                            child: Image.asset(R.resAssetsIconsIcNotifyBack),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          alignment: Alignment.topLeft,
                        ),
                        Row(
                          children: <Widget>[
                            Align(
                              child: GestureDetector(
                                child: Offstage(
                                    offstage: userMg.user.loginType != LoginType.cloud ||
                                        !userMg.hasBonus,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        SvgPicture.asset(R.resAssetsIconsIcRewardAccount),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Container(
                                          width: 25,
                                          child: Text(
                                            I18n.of(context).rewardAccount,
                                            style: StyleFactory.clickToRewardStyle,
                                          ),
                                        )
                                      ],
                                    )),
                                onTap: () async {
                                  showLoading(context);
                                  if (await userMg.loginWithPrivateKey(
                                      bonusEvent: true, accountName: userMg.user.name)) {
                                    showNotification(
                                        context, false, I18n.of(context).changeToReward,
                                        callback: () {
                                      Navigator.of(context).popUntil((route) => route.isFirst);
                                    });
                                  } else {
                                    showNotification(context, true, I18n.of(context).changeToTryEnv,
                                        callback: () {
                                      Navigator.of(context).popUntil((route) => route.isFirst);
                                    });
                                  }
                                },
                              ),
                              alignment: Alignment.centerRight,
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Align(
                              child: GestureDetector(
                                child: Offstage(
                                    offstage: userMg.user.loginType != LoginType.cloud,
                                    child: Row(
                                      children: <Widget>[
                                        SvgPicture.asset(R.resAssetsIconsIcTry),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Container(
                                          width: 25,
                                          child: Text(
                                            I18n.of(context).clickToTry,
                                            style: StyleFactory.clickToTryStyle,
                                          ),
                                        )
                                      ],
                                    )),
                                onTap: () async {
                                  showLoading(context);
                                  if (await userMg.loginWithPrivateKey(bonusEvent: false)) {
                                    showNotification(
                                        context, false, I18n.of(context).changeToTryEnv,
                                        callback: () {
                                      Navigator.of(context).popUntil((route) => route.isFirst);
                                    });
                                  } else {
                                    showNotification(context, true, I18n.of(context).changeToTryEnv,
                                        callback: () {
                                      Navigator.of(context).popUntil((route) => route.isFirst);
                                    });
                                  }
                                },
                              ),
                              alignment: Alignment.center,
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        Container(
                            width: 64,
                            height: 64,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: SvgPicture.string(
                                Jdenticon.toSvg(userMg.user.name ?? ""),
                                fit: BoxFit.cover,
                              ),
                            ),
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0x32b6c1cc),
                                    offset: Offset(0, 4),
                                    blurRadius: 8,
                                    spreadRadius: 2)
                              ],
                            )),
                        SizedBox(width: 20),
                        Flexible(
                          child: Text(
                            "Hi,${userMg.user.name}" ?? "--",
                            style: StyleFactory.hugeTitleStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                    // userMg.user.loginType == LoginType.reward
                    //     ? Text(
                    //         "活动结束时间: ${DateFormat("yyyy/MM/dd HH:mm").format(DateTime.fromMillisecondsSinceEpoch(userMg.user.testAccountResponseModel.expiration * 1000))}",
                    //         style: StyleFactory.cellDescLabel)
                    //     : Container(),
                    SizedBox(
                      height: 24,
                    ),
                    Text("${I18n.of(context).myAsset} (USDT)", style: StyleFactory.subTitleStyle),
                    SizedBox(height: 8),
                    Text(usdt == null ? "--" : "${floor(usdt.quantity, 4)}",
                        style: StyleFactory.hugeTitleStyle)
                  ],
                ),
              ),
              userMg.user.name == null
                  ? Container()
                  : Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          userMg.user.testAccountResponseModel == null
                              ? Container(
                                  margin: EdgeInsets.only(top: 24, right: 24, left: 24),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: userMg.depositAvailable
                                            ? () =>
                                                Navigator.of(context).pushNamed(RoutePaths.Deposit)
                                            : () {},
                                        child: Badge(
                                          showBadge: !userMg.depositAvailable,
                                          shape: BadgeShape.square,
                                          borderRadius: 5,
                                          padding: EdgeInsets.all(2),
                                          badgeContent: Text(
                                            I18n.of(context).suspend,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              SvgPicture.asset(
                                                R.resAssetsIconsIcDeposit,
                                              ),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                I18n.of(context).topUp,
                                                style: StyleFactory.smallCellTitleStyle,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: userMg.withdrawAvailable
                                            ? () =>
                                                Navigator.of(context).pushNamed(RoutePaths.Withdraw)
                                            : () {},
                                        child: Badge(
                                          showBadge: !userMg.withdrawAvailable,
                                          shape: BadgeShape.square,
                                          borderRadius: 5,
                                          padding: EdgeInsets.all(2),
                                          badgeContent: Text(
                                            I18n.of(context).suspend,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              SvgPicture.asset(
                                                R.resAssetsIconsIcWithdraw,
                                              ),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                I18n.of(context).withdraw,
                                                style: StyleFactory.smallCellTitleStyle,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () =>
                                            Navigator.pushNamed(context, RoutePaths.Transfer),
                                        child: Column(
                                          children: <Widget>[
                                            SvgPicture.asset(R.resAssetsIconsIcSend),
                                            SizedBox(
                                              height: 2,
                                            ),
                                            Text(
                                              I18n.of(context).transfer,
                                              style: StyleFactory.smallCellTitleStyle,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : Container(),
                          SizedBox(
                            height: 18,
                          ),
                          userMg.user.testAccountResponseModel == null &&
                                  locator.get<ConfigureApi>().bannersResponseList.isNotEmpty
                              ? _bannerWidget(
                                  items: locator.get<ConfigureApi>().bannersResponseList)
                              : Container(),
                          ListTile(
                            leading: SvgPicture.asset(R.resAssetsIconsIcWdrecords),
                            title: Text(
                              I18n.of(context).transactionRecords,
                              style: StyleFactory.larSubtitle,
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, RoutePaths.OrderRecords);
                            },
                          ),
                          userMg.user.testAccountResponseModel == null
                              ? ListTile(
                                  leading: SvgPicture.asset(R.resAssetsIconsIcExchangeRecords),
                                  title: Text(
                                    I18n.of(context).cashRecords,
                                    style: StyleFactory.larSubtitle,
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(context, RoutePaths.FundRecords);
                                  },
                                )
                              : Container(),
                          userMg.user.testAccountResponseModel == null
                              ? ListTile(
                                  leading: SvgPicture.asset(R.resAssetsIconsIcInvite),
                                  title: Row(
                                    children: <Widget>[
                                      Text(
                                        I18n.of(context).inviteFriend,
                                        style: StyleFactory.larSubtitle,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      SpeechBubble(
                                          nipLocation: NipLocation.LEFT,
                                          color: Palette.invitePromotionBadgeColor.withOpacity(0.1),
                                          padding: EdgeInsets.only(
                                              bottom: 1, top: 1, left: 12, right: 12),
                                          child: Container(
                                            child: Text("返利",
                                                style: StyleFactory.inviteBadgeFontStyle),
                                          ))
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(context, RoutePaths.Invite);
                                  },
                                )
                              : Container(),
                          ListTile(
                            leading: SvgPicture.asset(R.resAssetsIconsIcHelp),
                            title: Text(
                              I18n.of(context).helpCenter,
                              style: StyleFactory.larSubtitle,
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, RoutePaths.WebView);
                            },
                          ),
                          ListTile(
                            leading: SvgPicture.asset(R.resAssetsIconsIcHelp),
                            title: Text(
                              I18n.of(context).forum,
                              style: StyleFactory.larSubtitle,
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, RoutePaths.Forum);
                            },
                          ),
                          // false
                          //     ? ListTile(
                          //         title: Text(
                          //           I18n.of(context).changeEnv,
                          //           style: StyleFactory.cellTitleStyle,
                          //         ),
                          //         trailing: GestureDetector(
                          //           child:
                          //               Image.asset(R.resAssetsIconsIcTabArrow),
                          //           onTap: () {},
                          //         ),
                          //         onTap: () {
                          //           showCupertinoModalPopup(
                          //               context: context,
                          //               builder: (BuildContext context) {
                          //                 return CupertinoActionSheet(
                          //                   title: Text(
                          //                       I18n.of(context).chooseEnv),
                          //                   message: Text(I18n.of(context)
                          //                       .chooseEnvDetail),
                          //                   actions: <Widget>[
                          //                     CupertinoActionSheetAction(
                          //                       child: Text("PRO"),
                          //                       onPressed: () async {
                          //                         await locator
                          //                             .get<BBBAPI>()
                          //                             .setEnvMode(
                          //                                 envType: EnvType.Pro);
                          //                         await locator
                          //                             .get<GatewayApi>()
                          //                             .setEnvMode(
                          //                                 envType: EnvType.Pro);
                          //                         await locator
                          //                             .get<FaucetAPI>()
                          //                             .setEnvMode(
                          //                                 envType: EnvType.Pro);
                          //                         await locator
                          //                             .get<ReferApi>()
                          //                             .setEnvMode(
                          //                                 envType: EnvType.Pro);
                          //                         userMg.reload();
                          //                         Navigator.of(context).pop();
                          //                       },
                          //                       isDestructiveAction: locator
                          //                               .get<SharedPref>()
                          //                               .getEnvType() ==
                          //                           EnvType.Pro,
                          //                     ),
                          //                     CupertinoActionSheetAction(
                          //                       child: Text("UAT"),
                          //                       onPressed: () async {
                          //                         await locator
                          //                             .get<BBBAPI>()
                          //                             .setEnvMode(
                          //                                 envType: EnvType.Uat);
                          //                         await locator
                          //                             .get<GatewayApi>()
                          //                             .setEnvMode(
                          //                                 envType: EnvType.Uat);
                          //                         await locator
                          //                             .get<FaucetAPI>()
                          //                             .setEnvMode(
                          //                                 envType: EnvType.Uat);
                          //                         await locator
                          //                             .get<ReferApi>()
                          //                             .setEnvMode(
                          //                                 envType: EnvType.Uat);
                          //                         userMg.reload();
                          //                         Navigator.of(context).pop();
                          //                       },
                          //                       isDestructiveAction: locator
                          //                               .get<SharedPref>()
                          //                               .getEnvType() ==
                          //                           EnvType.Uat,
                          //                     )
                          //                   ],
                          //                   cancelButton:
                          //                       CupertinoActionSheetAction(
                          //                           onPressed: () {
                          //                             Navigator.of(context)
                          //                                 .pop();
                          //                           },
                          //                           child: Text(I18n.of(context)
                          //                               .dialogCancelButton)),
                          //                 );
                          //               });
                          //         },
                          //       )
                          //     : Container(),
                          userMg.user.name == null
                              ? Container()
                              : ListTile(
                                  leading: SvgPicture.asset(R.resAssetsIconsIcLogout),
                                  title: userMg.user.testAccountResponseModel != null
                                      ? (userMg.user.loginType == LoginType.reward
                                          ? Text(I18n.of(context).quitReward,
                                              style: StyleFactory.larSubtitle)
                                          : Text(I18n.of(context).clickToQuit,
                                              style: StyleFactory.larSubtitle))
                                      : Text(I18n.of(context).logout,
                                          style: StyleFactory.larSubtitle),
                                  onTap: () {
                                    if (userMg.user.testAccountResponseModel != null) {
                                      showNotification(
                                          context,
                                          false,
                                          userMg.user.loginType == LoginType.reward
                                              ? I18n.of(context).quitReward
                                              : I18n.of(context).changeFromTryEnv,
                                          callback: () async {
                                        await userMg.logoutTestAccount();
                                        Navigator.pop(context);
                                      });
                                    } else {
                                      userMg.logout();
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
                        ],
                      ),
                    ),
              Container(
                  alignment: Alignment.bottomRight,
                  margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Text(
                    "${I18n.of(context).version}: ${locator.get<PackageInfo>().version}",
                    style: StyleFactory.subTitleStyle,
                  ))
            ],
          ),
        );
      }),
    );
  }

  Widget _bannerWidget({List<BannerResponse> items}) {
    return CarouselSlider(
        viewportFraction: 0.92,
        aspectRatio: 269 / 66,
        autoPlay: items.length > 1,
        reverse: false,
        enableInfiniteScroll: items.length > 1,
        items: items.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  child: GestureDetector(
                      onTap: () {
                        if (i.link == null || i.link.isEmpty) {
                          return;
                        }
                        if (i.link.contains(HTTPString)) {
                          launchURL(url: Uri.encodeFull(i.link));
                        } else {
                          Navigator.of(context).pushNamed(i.link);
                        }
                      },
                      child: Image.network(i.image)));
            },
          );
        }).toList());
  }
}

import 'package:badges/badges.dart';
import 'package:bbb_flutter/helper/decimal_util.dart';
import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/helper/ui_utils.dart';
import 'package:bbb_flutter/helper/utils.dart';
import 'package:bbb_flutter/logic/account_vm.dart';
import 'package:bbb_flutter/logic/coupon_vm.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/positions_response_model.dart';
import 'package:bbb_flutter/routes/routes.dart';
import 'package:bbb_flutter/screen/home/home_view_model.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AccountPage extends StatefulWidget {
  AccountPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AccountPageState();
  }
}

class _AccountPageState extends State<AccountPage> {
  RefreshController _refreshController = new RefreshController();
  AccountViewModel _accountViewModel;
  CouponViewModel _couponViewModel;
  @override
  void initState() {
    _accountViewModel = locator.get<AccountViewModel>();
    _couponViewModel = locator.get();
    _accountViewModel.getGatewayInfo(assetName: AssetName.USDTERC20);
    _couponViewModel.getCoupons();
    locator.get<HomeViewModel>().getImageConfig();
    super.initState();
  }

  void _onRefresh() async {
    if (locator.get<UserManager>().user.logined) {
      await _couponViewModel.getCoupons();
      locator.get<UserManager>().fetchBalances(name: locator.get<UserManager>().user.name);
      _refreshController.refreshCompleted();
      _refreshController.resetNoData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _accountViewModel,
      child: Consumer3<UserManager, AccountViewModel, CouponViewModel>(
        builder: (context, userManager, accountVm, couponVm, child) {
          Position amount = userManager
              .fetchPositionFrom(locator.get<RefManager>().refDataControllerNew.value?.bbbAssetId);
          return Scaffold(
            backgroundColor: Palette.pagePrimaryColor,
            body: SafeArea(
              child: SmartRefresher(
                controller: _refreshController,
                onRefresh: _onRefresh,
                enablePullDown: userManager.user.logined,
                child: SingleChildScrollView(
                    child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              SvgPicture.asset(
                                R.resAssetsIconsIcAccountHeaderBackground,
                                width: ScreenUtil.screenWidthDp,
                                height: 202,
                                fit: BoxFit.fitHeight,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 18, left: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: userManager.user.logined
                                          ? () {}
                                          : () {
                                              Navigator.of(context).pushNamed(RoutePaths.Login);
                                            },
                                      child: Row(
                                        children: <Widget>[
                                          userManager.user.logined
                                              ? Container(
                                                  width: 50,
                                                  height: 50,
                                                  child: Padding(
                                                    padding: EdgeInsets.all(8),
                                                    child: SvgPicture.string(
                                                      Jdenticon.toSvg(userManager.user.name),
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
                                                  ))
                                              : SvgPicture.asset(
                                                  R.resAssetsIconsIcAccountAvatarNew,
                                                  width: 50,
                                                  height: 50,
                                                ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Flexible(
                                            child: Text(
                                              userManager.user.logined
                                                  ? "${userManager.user.name}"
                                                  : I18n.of(context).accountLoginRegiter,
                                              style: StyleNewFactory.black18,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    userManager.user.loginType == LoginType.cloud ||
                                            userManager.user.loginType == LoginType.none
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16, bottom: 12, left: 15, right: 47),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                GestureDetector(
                                                  onTap: accountVm.depositAvailable
                                                      ? () => Navigator.of(context)
                                                          .pushNamed(RoutePaths.Deposit)
                                                      : () {},
                                                  child: Badge(
                                                    showBadge: !accountVm.depositAvailable,
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
                                                          R.resAssetsIconsIcDepositNew,
                                                          width: 27,
                                                          height: 27,
                                                        ),
                                                        SizedBox(
                                                          height: 7,
                                                        ),
                                                        Text(
                                                          I18n.of(context).topUp,
                                                          style: StyleNewFactory.black15,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: accountVm.withdrawAvailable
                                                      ? () => Navigator.of(context)
                                                          .pushNamed(RoutePaths.Withdraw)
                                                      : () {},
                                                  child: Badge(
                                                    showBadge: !accountVm.withdrawAvailable,
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
                                                          R.resAssetsIconsIcWithdrawNew,
                                                          width: 27,
                                                          height: 27,
                                                        ),
                                                        SizedBox(
                                                          height: 7,
                                                        ),
                                                        Text(
                                                          I18n.of(context).withdraw,
                                                          style: StyleNewFactory.black15,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () => Navigator.of(context)
                                                      .pushNamed(RoutePaths.Transfer),
                                                  child: Column(
                                                    children: <Widget>[
                                                      SvgPicture.asset(
                                                        R.resAssetsIconsIcTransferNew,
                                                        width: 27,
                                                        height: 27,
                                                      ),
                                                      SizedBox(
                                                        height: 7,
                                                      ),
                                                      Text(
                                                        I18n.of(context).transfer,
                                                        style: StyleNewFactory.black15,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.of(context).pushNamed(RoutePaths.Setting),
                                child: Container(
                                  alignment: Alignment.topRight,
                                  margin: EdgeInsets.only(top: 18, right: 15),
                                  child: SvgPicture.asset(
                                    R.resAssetsIconsSetting,
                                    width: 22,
                                    height: 22,
                                  ),
                                ),
                              ),
                              Align(
                                child: Container(
                                  width: ScreenUtil.getInstance().setWidth(345),
                                  margin: EdgeInsets.only(top: 152),
                                  padding: EdgeInsets.only(left: 15, top: 12),
                                  decoration: BoxDecoration(
                                      color: Palette.buttonPrimaryColor,
                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      boxShadow: [StyleFactory.shadow]),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                I18n.of(context).accountMyAsset,
                                                style: StyleNewFactory.grey15,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              GestureDetector(
                                                onTap: accountVm.showAccountAmount,
                                                child: accountVm.showAmount
                                                    ? Icon(
                                                        Icons.visibility,
                                                        color: Palette.appCellTitlelightGrey,
                                                      )
                                                    : Icon(
                                                        Icons.visibility_off,
                                                        color: Palette.appCellTitlelightGrey,
                                                      ),
                                              )
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: userManager.user.loginType == LoginType.cloud ||
                                                    userManager.user.loginType == LoginType.none
                                                ? () async {
                                                    showLoading(context);
                                                    if (await userManager.loginWithPrivateKey(
                                                        bonusEvent: false)) {
                                                      Navigator.of(context)
                                                          .popUntil((route) => route.isFirst);
                                                      showFlashBar(context, false,
                                                          content: I18n.of(context).changeToTryEnv);
                                                    } else {
                                                      Navigator.of(context)
                                                          .popUntil((route) => route.isFirst);
                                                      showFlashBar(context, false,
                                                          content: I18n.of(context).changeToTryEnv);
                                                    }
                                                  }
                                                : () {},
                                            child: userManager.user.loginType == LoginType.cloud ||
                                                    userManager.user.loginType == LoginType.none
                                                ? Badge(
                                                    showBadge: true,
                                                    badgeColor: Palette.appYellowOrange,
                                                    badgeContent: Text("点我试试",
                                                        style: StyleNewFactory.white14),
                                                    shape: BadgeShape.square,
                                                    padding: EdgeInsets.symmetric(
                                                        vertical: 1, horizontal: 18),
                                                    borderRadius: 5,
                                                  )
                                                : Container(),
                                          ),
                                        ],
                                      ),
                                      accountVm.showAmount
                                          ? Text(
                                              amount?.quantity == null
                                                  ? "--"
                                                  : "${floor(amount.quantity, 4)}",
                                              style: StyleNewFactory.black30,
                                            )
                                          : Text("**********", style: StyleNewFactory.black30),
                                      SizedBox(
                                        height: 6.5,
                                      ),
                                      Divider(
                                        color: Color(0xfff7f7f7),
                                        thickness: 1,
                                        height: 1,
                                        endIndent: 15,
                                      ),
                                      userManager.user.loginType == LoginType.cloud ||
                                              userManager.user.loginType == LoginType.none
                                          ? ListTile(
                                              contentPadding: EdgeInsets.all(0),
                                              title: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    I18n.of(context).accountRewardAmount,
                                                    style: StyleNewFactory.grey15,
                                                  ),
                                                  Text(
                                                      couponVm.totalAmount == null
                                                          ? "--"
                                                          : couponVm.totalAmount.toStringAsFixed(4),
                                                      style: StyleNewFactory.yellowOrange18),
                                                  Text(
                                                    "  ${AssetName.USDT}",
                                                    style: StyleNewFactory.grey12,
                                                  )
                                                ],
                                              ),
                                              trailing: GestureDetector(
                                                onTap: () async {
                                                  // showLoading(context);
                                                  // if (await userManager.loginReward(action: locator.get<RefManager>().actions.where((i) => i.name.contains("reward")).toList().first.name)) {
                                                  //   Navigator.of(context).popUntil((route) => route.isFirst);
                                                  //   showFlashBar(context, false, content: I18n.of(context).changeToReward);
                                                  // } else {
                                                  //   Navigator.of(context).popUntil((route) => route.isFirst);
                                                  //   showFlashBar(context, true, content: I18n.of(context).changeToReward);
                                                  // }
                                                  Navigator.of(context)
                                                      .pushNamed(RoutePaths.Coupon);
                                                },
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
                                                    Text(
                                                      I18n.of(context).accountToUseReward,
                                                      style: StyleNewFactory.grey15,
                                                    ),
                                                    Icon(Icons.keyboard_arrow_right),
                                                  ],
                                                ),
                                              ))
                                          : userManager.user.loginType == LoginType.test
                                              ? Container(
                                                  padding: EdgeInsets.symmetric(vertical: 10),
                                                  child: Text("试玩账户盈利不可提现",
                                                      style: StyleNewFactory.grey15))
                                              : Container(
                                                  padding: EdgeInsets.symmetric(vertical: 10),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                          "活动时间: ${locator.get<RefManager>().action != null ? dateFormat(date: locator.get<RefManager>().action.start, formatter: "MM/dd HH:mm") : "--"} - ${locator.get<RefManager>().action != null ? dateFormat(date: locator.get<RefManager>().action.stop, formatter: "MM/dd HH:mm") : "--"}",
                                                          style: StyleNewFactory.grey15),
                                                    ],
                                                  )),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          // userManager.user.loginType == LoginType.reward
                          //     ? Container(
                          //         alignment: Alignment.centerLeft,
                          //         margin: EdgeInsets.only(top: 10),
                          //         child: Text(
                          //             "活动结束时间: ${_accountViewModel.action != null ? DateFormat("yyyy/MM/dd HH:mm").format(DateTime.parse(locator.get<RefManager>().actions.where((value) => value.name.contains("reward")).toList().first.stop).toLocal()) : "--"}",
                          //             style: StyleNewFactory.grey15))
                          //     : Container(),
                          Divider(
                            color: Color(0xfff7f7f7),
                            thickness: 1,
                            height: 1,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          userManager.user.loginType == LoginType.cloud ||
                                  userManager.user.loginType == LoginType.none
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(RoutePaths.Invite);
                                  },
                                  child: showNetworkImageWrapper(
                                    url: locator
                                            .get<HomeViewModel>()
                                            .imageConfigResponse
                                            ?.result
                                            ?.referEntry ??
                                        "https://config-center.cybex.io/prod/bbb/ver2-0-9/refer_entry.1589787111457.png",
                                    height: ScreenUtil.getInstance().setHeight(80),
                                    width: ScreenUtil.getInstance().setWidth(345),
                                  ))
                              : Container(),
                          userManager.user.loginType == LoginType.reward
                              ? ListTile(
                                  trailing: Icon(Icons.keyboard_arrow_right),
                                  title: Text(
                                    "大赛排名",
                                    style: StyleNewFactory.black15,
                                  ),
                                  onTap: () {
                                    jumpToUrl(
                                        locator
                                                .get<HomeViewModel>()
                                                .imageConfigResponse
                                                ?.result
                                                ?.competitionRankingLink ??
                                            "https://config-center.cybex.io/prod/bbb/ver2-0-9/refer_entry.1589787111457.png",
                                        context,
                                        needLogIn: false);
                                  },
                                )
                              : Container(),

                          Divider(
                            color: Palette.appDividerBackgroudGreyColor,
                            thickness: 1,
                            height: 1,
                          ),

                          ListTile(
                            trailing: Icon(Icons.keyboard_arrow_right),
                            title: Text(
                              I18n.of(context).transactionRecords,
                              style: StyleNewFactory.black15,
                            ),
                            onTap: () {
                              Navigator.of(context).pushNamed(RoutePaths.OrderRecords);
                            },
                          ),
                          Divider(
                            color: Palette.appDividerBackgroudGreyColor,
                            thickness: 1,
                            height: 1,
                          ),
                          ListTile(
                            trailing: Icon(Icons.keyboard_arrow_right),
                            title: Text(
                              I18n.of(context).limitOrderRecords,
                              style: StyleNewFactory.black15,
                            ),
                            onTap: () {
                              Navigator.of(context).pushNamed(RoutePaths.LimitOrderRecords);
                            },
                          ),
                          Divider(
                            color: Palette.appDividerBackgroudGreyColor,
                            thickness: 1,
                            height: 1,
                          ),
                          userManager.user.loginType == LoginType.cloud ||
                                  userManager.user.loginType == LoginType.none
                              ? ListTile(
                                  trailing: Icon(Icons.keyboard_arrow_right),
                                  title: Text(
                                    I18n.of(context).cashRecords,
                                    style: StyleNewFactory.black15,
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pushNamed(RoutePaths.FundRecords);
                                  },
                                )
                              : Container(),
                          Divider(
                            color: Palette.appDividerBackgroudGreyColor,
                            thickness: 1,
                            height: 1,
                          ),
                          userManager.user.loginType == LoginType.cloud ||
                                  userManager.user.loginType == LoginType.none
                              ? ListTile(
                                  trailing: Icon(Icons.keyboard_arrow_right),
                                  title: Text(
                                    I18n.of(context).rewardRecords,
                                    style: StyleNewFactory.black15,
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pushNamed(RoutePaths.RewardRecords);
                                  },
                                )
                              : Container(),
                          Divider(
                            color: Palette.appDividerBackgroudGreyColor,
                            thickness: 1,
                            height: 1,
                          ),
                          ListTile(
                            trailing: Icon(Icons.keyboard_arrow_right),
                            title: Text(
                              I18n.of(context).helpCenter,
                              style: StyleNewFactory.black15,
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, RoutePaths.WebView, arguments: {
                                "title": I18n.of(context).helpCenter,
                                "url":
                                    "https://bbb-kb.cybex.io/?knowledgebase_cat=%e5%b8%ae%e5%8a%a9%e4%b8%ad%e5%bf%83"
                              });
                            },
                          ),
                          Divider(
                            color: Palette.appDividerBackgroudGreyColor,
                            thickness: 10,
                            height: 1,
                          ),
                          // userManager.user.loginType == LoginType.cloud ||
                          //         userManager.user.loginType == LoginType.none
                          //     ? GestureDetector(
                          //         onTap: () {
                          //           _accountViewModel.puchToNextPage(
                          //               userManager.user.logined, RoutePaths.Invite, context);
                          //         },
                          //         child: Image.network(
                          //           locator.get<HomeViewModel>().imageConfigResponse.result.referEntry,
                          //           height: ScreenUtil.getInstance().setHeight(105),
                          //           width: ScreenUtil.getInstance().setWidth(375),
                          //         ),
                          //       )
                          // ? ListTile(
                          //     trailing: Icon(Icons.keyboard_arrow_right),
                          //     title: Row(
                          //       children: <Widget>[
                          //         Text(
                          //           I18n.of(context).inviteFriend,
                          //           style: StyleNewFactory.black15,
                          //         ),
                          //         SizedBox(
                          //           width: 10,
                          //         ),
                          //         SpeechBubble(
                          //             nipLocation: NipLocation.LEFT,
                          //             color: Palette.invitePromotionBadgeColor.withOpacity(0.1),
                          //             padding: EdgeInsets.only(
                          //                 bottom: 1, top: 1, left: 12, right: 12),
                          //             child: Container(
                          //               child: Text("返利",
                          //                   style: StyleFactory.inviteBadgeFontStyle),
                          //             ))
                          //       ],
                          //     ),
                          //     onTap: () {
                          //       _accountViewModel.puchToNextPage(
                          //           userManager.user.logined, RoutePaths.Invite, context);
                          //     },
                          //   )
                          // : Container(),
                          SizedBox(
                            height: 50,
                          ),
                          userManager.user.loginType == LoginType.test ||
                                  userManager.user.loginType == LoginType.reward
                              ? GestureDetector(
                                  onTap: () {
                                    if (userManager.user.testAccountResponseModel != null) {
                                      showFlashBar(context, false,
                                          content: I18n.of(context).changeFromTryEnv,
                                          callback: () async {
                                        await userManager.logoutTestAccount();
                                      });
                                    } else {
                                      showFlashBar(context, false,
                                          content: I18n.of(context).quitReward, callback: () async {
                                        await userManager.logOutRewardAccount();
                                      });
                                    }
                                  },
                                  child: Container(
                                      width: 275,
                                      height: 47,
                                      margin: EdgeInsets.only(bottom: 50),
                                      child: Center(
                                          child: userManager.user.loginType == LoginType.test
                                              ? Text(I18n.of(context).clickToQuit,
                                                  style: StyleNewFactory.yellowOrange18)
                                              : Text(I18n.of(context).quitReward,
                                                  style: StyleNewFactory.yellowOrange18)),
                                      decoration: new BoxDecoration(
                                          border:
                                              Border.all(color: Palette.appYellowOrange, width: 1),
                                          borderRadius: BorderRadius.circular(5))),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ],
                )),
              ),
            ),
          );
        },
      ),
    );
  }
}

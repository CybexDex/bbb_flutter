import 'package:badges/badges.dart';
import 'package:bbb_flutter/helper/decimal_util.dart';
import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/logic/account_vm.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/positions_response_model.dart';
import 'package:bbb_flutter/routes/routes.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/speech_bubble.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:intl/intl.dart';

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

  @override
  void initState() {
    _accountViewModel = locator.get<AccountViewModel>();
    _accountViewModel.getGatewayInfo(assetName: AssetName.USDTERC20);
    _accountViewModel.checkRewardAccount(
        accountName: locator.get<UserManager>().user.name, bonusEvent: true);
    super.initState();
  }

  void _onRefresh() async {
    if (locator.get<UserManager>().user.logined) {
      await _accountViewModel.checkRewardAccount(
          accountName: locator.get<UserManager>().user.name, bonusEvent: true);
      locator
          .get<UserManager>()
          .fetchBalances(name: locator.get<UserManager>().user.name);
      _refreshController.refreshCompleted();
      _refreshController.resetNoData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _accountViewModel,
      child: Consumer2<UserManager, AccountViewModel>(
        builder: (context, userManager, accountVm, child) {
          Position amount = userManager.fetchPositionFrom(
              locator.get<RefManager>().refDataControllerNew.value?.bbbAssetId);
          return Scaffold(
            backgroundColor: Palette.appDividerBackgroudGreyColor,
            appBar: AppBar(
              backgroundColor: Colors.white,
              brightness: Brightness.light,
              elevation: 0,
              actions: <Widget>[
                GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushNamed(RoutePaths.Setting),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: SvgPicture.asset(
                      R.resAssetsIconsIcSetting,
                      width: 21,
                      height: 21,
                    ),
                  ),
                )
              ],
            ),
            body: SmartRefresher(
              controller: _refreshController,
              onRefresh: _onRefresh,
              enablePullDown: userManager.user.logined,
              child: SingleChildScrollView(
                  child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(right: 15, left: 15),
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            SvgPicture.asset(
                              R.resAssetsIconsIcAccountHeaderBackground,
                              width: ScreenUtil.getInstance().setWidth(345),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10, left: 18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: userManager.user.logined
                                        ? () {}
                                        : () {
                                            Navigator.of(context)
                                                .pushNamed(RoutePaths.Login);
                                          },
                                    child: Row(
                                      children: <Widget>[
                                        userManager.user.logined
                                            ? Container(
                                                width: 55,
                                                height: 55,
                                                child: Padding(
                                                  padding: EdgeInsets.all(8),
                                                  child: SvgPicture.string(
                                                    Jdenticon.toSvg(
                                                        userManager.user.name),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                decoration: new BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color:
                                                            Color(0x32b6c1cc),
                                                        offset: Offset(0, 4),
                                                        blurRadius: 8,
                                                        spreadRadius: 2)
                                                  ],
                                                ))
                                            : SvgPicture.asset(
                                                R.resAssetsIconsIcAccountAvatarNew,
                                                width: 55,
                                                height: 55,
                                              ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: Text(
                                            userManager.user.logined
                                                ? "${userManager.user.name}"
                                                : I18n.of(context)
                                                    .accountLoginRegiter,
                                            style: StyleNewFactory.black18,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      accountVm.showAmount
                                          ? Text(
                                              amount?.quantity == null
                                                  ? "--"
                                                  : "${floor(amount.quantity, 4)}",
                                              style: StyleNewFactory.black26,
                                            )
                                          : Text("**********",
                                              style: StyleNewFactory.black26),
                                      SizedBox(
                                        width: 40,
                                      ),
                                      GestureDetector(
                                        onTap: accountVm.showAccountAmount,
                                        child: accountVm.showAmount
                                            ? SvgPicture.asset(
                                                R.resAssetsIconsIcEyeClose,
                                                width: 20,
                                                height: 13,
                                              )
                                            : SvgPicture.asset(
                                                R.resAssetsIconsIcEyeOpen,
                                                width: 20,
                                                height: 13,
                                              ),
                                      )
                                    ],
                                  ),
                                  Text(
                                    I18n.of(context).accountMyAsset,
                                    style: StyleNewFactory.black15,
                                  )
                                ],
                              ),
                            ),
                            userManager.user.loginType == LoginType.cloud ||
                                    userManager.user.loginType == LoginType.none
                                ? GestureDetector(
                                    onTap: () async {
                                      showLoading(context);
                                      if (await userManager.loginWithPrivateKey(
                                          bonusEvent: false)) {
                                        Navigator.of(context)
                                            .popUntil((route) => route.isFirst);
                                        showFlashBar(context, false,
                                            content: I18n.of(context)
                                                .changeToTryEnv);
                                      } else {
                                        Navigator.of(context)
                                            .popUntil((route) => route.isFirst);
                                        showFlashBar(context, false,
                                            content: I18n.of(context)
                                                .changeToTryEnv);
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.topRight,
                                      margin:
                                          EdgeInsets.only(top: 24, right: 24),
                                      child: SvgPicture.asset(
                                        R.resAssetsIconsIcClickTryNew,
                                        width: 83,
                                        height: 43,
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                        userManager.user.loginType == LoginType.reward
                            ? Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(top: 10),
                                child: Text(
                                    "活动结束时间: ${_accountViewModel.action != null ? DateFormat("yyyy/MM/dd HH:mm").format(DateTime.parse(locator.get<RefManager>().actions.where((value) => value.name.contains("reward")).toList().first.stop).toLocal()) : "--"}",
                                    style: StyleNewFactory.grey15))
                            : Container(),
                        userManager.user.loginType != LoginType.cloud ||
                                !_accountViewModel.hasBonus
                            ? Container()
                            : ListTile(
                                contentPadding: EdgeInsets.all(0),
                                title: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      I18n.of(context).accountRewardAmount,
                                      style: StyleNewFactory.grey15,
                                    ),
                                    Text(
                                        _accountViewModel
                                                    .bounusAccountBalance ==
                                                null
                                            ? "--"
                                            : _accountViewModel
                                                .bounusAccountBalance.quantity
                                                .toStringAsFixed(4),
                                        style: StyleNewFactory.yellowOrange18),
                                    Text(
                                      "  ${AssetName.USDT}",
                                      style: StyleNewFactory.grey12,
                                    )
                                  ],
                                ),
                                trailing: GestureDetector(
                                  onTap: () async {
                                    showLoading(context);
                                    if (await userManager.loginReward(
                                        action: locator
                                            .get<RefManager>()
                                            .actions
                                            .where((i) =>
                                                i.name.contains("reward"))
                                            .toList()
                                            .first
                                            .name)) {
                                      Navigator.of(context)
                                          .popUntil((route) => route.isFirst);
                                      showFlashBar(context, false,
                                          content:
                                              I18n.of(context).changeToReward);
                                    } else {
                                      Navigator.of(context)
                                          .popUntil((route) => route.isFirst);
                                      showFlashBar(context, true,
                                          content:
                                              I18n.of(context).changeToReward);
                                    }
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
                                )),
                        Divider(
                          color: Color(0xfff7f7f7),
                          thickness: 1,
                          height: 1,
                        ),
                        userManager.user.loginType == LoginType.cloud ||
                                userManager.user.loginType == LoginType.none
                            ? Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(21, 17, 21, 12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: accountVm.depositAvailable
                                          ? () =>
                                              _accountViewModel.puchToNextPage(
                                                  userManager.user.logined,
                                                  RoutePaths.Deposit,
                                                  context)
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
                                              width: 30,
                                              height: 30,
                                            ),
                                            SizedBox(
                                              height: 7,
                                            ),
                                            Text(
                                              I18n.of(context).topUp,
                                              style: StyleNewFactory.grey15,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: accountVm.withdrawAvailable
                                          ? () =>
                                              _accountViewModel.puchToNextPage(
                                                  userManager.user.logined,
                                                  RoutePaths.Withdraw,
                                                  context)
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
                                              width: 30,
                                              height: 30,
                                            ),
                                            SizedBox(
                                              height: 7,
                                            ),
                                            Text(
                                              I18n.of(context).withdraw,
                                              style: StyleNewFactory.grey15,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () =>
                                          _accountViewModel.puchToNextPage(
                                              userManager.user.logined,
                                              RoutePaths.Transfer,
                                              context),
                                      child: Column(
                                        children: <Widget>[
                                          SvgPicture.asset(
                                            R.resAssetsIconsIcTransferNew,
                                            width: 30,
                                            height: 30,
                                          ),
                                          SizedBox(
                                            height: 7,
                                          ),
                                          Text(
                                            I18n.of(context).transfer,
                                            style: StyleNewFactory.grey15,
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
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          trailing: Icon(Icons.keyboard_arrow_right),
                          title: Text(
                            I18n.of(context).transactionRecords,
                            style: StyleNewFactory.black15,
                          ),
                          onTap: () {
                            _accountViewModel.puchToNextPage(
                                userManager.user.logined,
                                RoutePaths.OrderRecords,
                                context);
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
                            _accountViewModel.puchToNextPage(
                                userManager.user.logined,
                                RoutePaths.LimitOrderRecords,
                                context);
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
                                  _accountViewModel.puchToNextPage(
                                      userManager.user.logined,
                                      RoutePaths.FundRecords,
                                      context);
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
                            Navigator.pushNamed(context, RoutePaths.Help);
                          },
                        ),
                        Divider(
                          color: Palette.appDividerBackgroudGreyColor,
                          thickness: 10,
                          height: 1,
                        ),
                        userManager.user.loginType == LoginType.cloud ||
                                userManager.user.loginType == LoginType.none
                            ? ListTile(
                                trailing: Icon(Icons.keyboard_arrow_right),
                                title: Row(
                                  children: <Widget>[
                                    Text(
                                      I18n.of(context).inviteFriend,
                                      style: StyleNewFactory.black15,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    SpeechBubble(
                                        nipLocation: NipLocation.LEFT,
                                        color: Palette.invitePromotionBadgeColor
                                            .withOpacity(0.1),
                                        padding: EdgeInsets.only(
                                            bottom: 1,
                                            top: 1,
                                            left: 12,
                                            right: 12),
                                        child: Container(
                                          child: Text("返利",
                                              style: StyleFactory
                                                  .inviteBadgeFontStyle),
                                        ))
                                  ],
                                ),
                                onTap: () {
                                  _accountViewModel.puchToNextPage(
                                      userManager.user.logined,
                                      RoutePaths.Invite,
                                      context);
                                },
                              )
                            : Container()
                      ],
                    ),
                  ),
                ],
              )),
            ),
          );
        },
      ),
    );
  }
}

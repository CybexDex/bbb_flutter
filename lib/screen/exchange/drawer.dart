import 'package:bbb_flutter/cache/shared_pref.dart';
import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/positions_response_model.dart';
import 'package:bbb_flutter/routes/routes.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';

import '../../env.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the Drawer if there isn't enough vertical
      // space to fit everything.
      child: Consumer<UserManager>(builder: (context, userMg, child) {
        Position usdt = userMg.fetchPositionFrom(AssetName.NXUSDT);

        return ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 8, top: 30),
              padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
              child: Column(
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
                      Align(
                        child: GestureDetector(
                          child: Offstage(
                            offstage:
                                userMg.user.testAccountResponseModel != null,
                            child: Text(
                              I18n.of(context).clickToTry,
                              style: StyleFactory.buyUpCellLabel,
                            ),
                          ),
                          onTap: () {
                            userMg.loginWithPrivateKey();
                          },
                        ),
                        alignment: Alignment.center,
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      SvgPicture.string(Jdenticon.toSvg(userMg.user.name ?? ""),
                          fit: BoxFit.contain, height: 60, width: 60),
                      SizedBox(width: 20),
                      Flexible(
                        child: Text(
                          userMg.user.name ?? "--",
                          style: StyleFactory.title,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                      width: 300,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Palette.buttonPrimaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 4,
                              color: Palette.actionButtonColor.withOpacity(0.1),
                              offset: Offset(0, 4))
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(I18n.of(context).myAsset,
                              style: StyleFactory.cellTitleStyle),
                          SizedBox(height: 10),
                          Text(
                              usdt == null
                                  ? "--"
                                  : "${usdt.quantity.toStringAsFixed(4)} USDT",
                              style: StyleFactory.hugeTitleStyle)
                        ],
                      ))
                ],
              ),
            ),
            userMg.user.name == null
                ? Container()
                : Container(
                    child: Column(
                      children: <Widget>[
                        userMg.user.testAccountResponseModel == null
                            ? ListTile(
                                title: Text(
                                  I18n.of(context).topUp,
                                  style: StyleFactory.cellTitleStyle,
                                ),
                                trailing: GestureDetector(
                                  child:
                                      Image.asset(R.resAssetsIconsIcTabArrow),
                                  onTap: () {},
                                ),
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(RoutePaths.Deposit);
                                },
                              )
                            : Container(),
                        userMg.user.testAccountResponseModel == null
                            ? Container(
                                height: 0.5,
                                margin: EdgeInsets.only(left: 20, right: 20),
                                color: Palette.separatorColor,
                              )
                            : Container(),
                        userMg.user.testAccountResponseModel == null
                            ? ListTile(
                                title: Text(
                                  I18n.of(context).withdraw,
                                  style: StyleFactory.cellTitleStyle,
                                ),
                                trailing: GestureDetector(
                                  child:
                                      Image.asset(R.resAssetsIconsIcTabArrow),
                                  onTap: () {},
                                ),
                                onTap: () {
                                  // Update the state of the app
                                  // ...
                                  Navigator.pushNamed(
                                      context, RoutePaths.Withdraw);
                                },
                              )
                            : Container(),
                        userMg.user.testAccountResponseModel == null
                            ? Container(
                                height: 0.5,
                                margin: EdgeInsets.only(left: 20, right: 20),
                                color: Palette.separatorColor,
                              )
                            : Container(),
                        userMg.user.testAccountResponseModel == null
                            ? ListTile(
                                title: Text(
                                  I18n.of(context).cashRecords,
                                  style: StyleFactory.cellTitleStyle,
                                ),
                                trailing: GestureDetector(
                                  child:
                                      Image.asset(R.resAssetsIconsIcTabArrow),
                                  onTap: () {},
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RoutePaths.FundRecords);
                                },
                              )
                            : Container(),
                        userMg.user.testAccountResponseModel == null
                            ? Container(
                                height: 0.5,
                                margin: EdgeInsets.only(left: 20, right: 20),
                                color: Palette.separatorColor,
                              )
                            : Container(),
                        ListTile(
                          title: Text(
                            I18n.of(context).transactionRecords,
                            style: StyleFactory.cellTitleStyle,
                          ),
                          trailing: GestureDetector(
                            child: Image.asset(R.resAssetsIconsIcTabArrow),
                            onTap: () {},
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                                context, RoutePaths.OrderRecords);
                          },
                        ),
                        Container(
                          height: 0.5,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          color: Palette.separatorColor,
                        ),
                        userMg.user.testAccountResponseModel == null
                            ? ListTile(
                                title: Text(
                                  I18n.of(context).transfer,
                                  style: StyleFactory.cellTitleStyle,
                                ),
                                trailing: GestureDetector(
                                  child:
                                      Image.asset(R.resAssetsIconsIcTabArrow),
                                  onTap: () {},
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RoutePaths.Transfer);
                                },
                              )
                            : Container(),
                        Container(
                          height: 0.5,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          color: Palette.separatorColor,
                        ),
                        userMg.user.testAccountResponseModel == null
                            ? ListTile(
                                title: Text(
                                  I18n.of(context).inviteFriend,
                                  style: StyleFactory.cellTitleStyle,
                                ),
                                trailing: GestureDetector(
                                  child:
                                      Image.asset(R.resAssetsIconsIcTabArrow),
                                  onTap: () {},
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RoutePaths.Invite);
                                },
                              )
                            : Container(),
                        Container(
                          height: 0.5,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          color: Palette.separatorColor,
                        ),
                        BuildMode.debug == buildMode
                            ? ListTile(
                                title: Text(
                                  I18n.of(context).changeEnv,
                                  style: StyleFactory.cellTitleStyle,
                                ),
                                trailing: GestureDetector(
                                  child:
                                      Image.asset(R.resAssetsIconsIcTabArrow),
                                  onTap: () {},
                                ),
                                onTap: () {
                                  showCupertinoModalPopup(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CupertinoActionSheet(
                                          title:
                                              Text(I18n.of(context).chooseEnv),
                                          message: Text(
                                              I18n.of(context).chooseEnvDetail),
                                          actions: <Widget>[
                                            CupertinoActionSheetAction(
                                              child: Text("PRO"),
                                              onPressed: () async {
                                                await locator
                                                    .get<BBBAPI>()
                                                    .setEnvMode(
                                                        envType: EnvType.Pro);
                                                userMg.reload();
                                                Navigator.of(context).pop();
                                              },
                                              isDestructiveAction: locator
                                                      .get<SharedPref>()
                                                      .getEnvType() ==
                                                  EnvType.Pro,
                                            ),
                                            CupertinoActionSheetAction(
                                              child: Text("UAT"),
                                              onPressed: () async {
                                                await locator
                                                    .get<BBBAPI>()
                                                    .setEnvMode(
                                                        envType: EnvType.Uat);
                                                userMg.reload();
                                                Navigator.of(context).pop();
                                              },
                                              isDestructiveAction: locator
                                                      .get<SharedPref>()
                                                      .getEnvType() ==
                                                  EnvType.Uat,
                                            )
                                          ],
                                          cancelButton:
                                              CupertinoActionSheetAction(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(I18n.of(context)
                                                      .dialogCancelButton)),
                                        );
                                      });
                                },
                              )
                            : Container(),
                        Container(
                          height: 0.5,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          color: Palette.separatorColor,
                        ),
                      ],
                    ),
                  ),
            Container(
              margin: EdgeInsets.only(top: 40, left: 20, right: 20),
              child: userMg.user.name == null
                  ? WidgetFactory.button(
                      data: I18n.of(context).logIn,
                      color: Palette.shamrockGreen,
                      onPressed: () {
                        Navigator.of(context).pushNamed(RoutePaths.Login);
                      })
                  : WidgetFactory.button(
                      data: userMg.user.testAccountResponseModel != null
                          ? I18n.of(context).clickToQuit
                          : I18n.of(context).logout,
                      color: Palette.redOrange,
                      onPressed: () {
                        if (userMg.user.testAccountResponseModel != null) {
                          userMg.logoutTestAccount();
                          showToast(
                              context, false, I18n.of(context).changeFromTryEnv,
                              callback: () {
                            Navigator.pop(context);
                          });
                        } else {
                          userMg.logout();
                          Navigator.pop(context);
                        }
                      }),
            ),
          ],
        );
      }),
    );
  }
}

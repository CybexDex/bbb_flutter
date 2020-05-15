import 'dart:io';

import 'package:bbb_flutter/cache/shared_pref.dart';
import 'package:bbb_flutter/env.dart';
import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/logic/account_vm.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/update_response.dart';
import 'package:bbb_flutter/routes/routes.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api.dart';
import 'package:bbb_flutter/services/network/configure/configure_api.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info/package_info.dart';

class SettingWiget extends StatefulWidget {
  SettingWiget({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SettingState();
  }
}

class _SettingState extends State<SettingWiget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Palette.appDividerBackgroudGreyColor,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Palette.backButtonColor, //change your color here
          ),
          centerTitle: true,
          title: Text("设置", style: StyleFactory.title),
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          elevation: 0,
        ),
        body: Consumer<UserManager>(
          builder: (context, userManager, child) {
            return Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      color: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            trailing: Icon(Icons.keyboard_arrow_right),
                            title: Text(
                              "在线客服",
                              style: StyleNewFactory.black15,
                            ),
                            onTap: () {
                              Navigator.of(context).pushNamed(RoutePaths.Feedback);
                            },
                          ),
                          Divider(
                            color: Palette.appDividerBackgroudGreyColor,
                            thickness: 1,
                            height: 1,
                          ),
                          ListTile(
                            trailing: Text(
                              "${I18n.of(context).version}: V${locator.get<PackageInfo>().version}",
                              style: StyleNewFactory.grey14,
                            ),
                            title: Text(
                              "检查更新",
                              style: StyleNewFactory.black15,
                            ),
                            onTap: _checkConfiguretion,
                          ),
                          BuildMode.debug == buildMode
                              ? ListTile(
                                  title: Text(
                                    I18n.of(context).changeEnv,
                                    style: StyleFactory.cellTitleStyle,
                                  ),
                                  trailing: GestureDetector(
                                    child: Icon(Icons.keyboard_arrow_right),
                                    onTap: () {},
                                  ),
                                  onTap: () {
                                    showCupertinoModalPopup(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CupertinoActionSheet(
                                            title: Text(I18n.of(context).chooseEnv),
                                            message: Text(I18n.of(context).chooseEnvDetail),
                                            actions: <Widget>[
                                              CupertinoActionSheetAction(
                                                child: Text("PRO"),
                                                onPressed: () async {
                                                  await locator
                                                      .get<BBBAPI>()
                                                      .setEnvMode(envType: EnvType.Pro);
                                                  userManager.reload();
                                                  Navigator.of(context).pop();
                                                },
                                                isDestructiveAction:
                                                    locator.get<SharedPref>().getEnvType() ==
                                                        EnvType.Pro,
                                              ),
                                              CupertinoActionSheetAction(
                                                child: Text("TEST"),
                                                onPressed: () async {
                                                  await locator
                                                      .get<BBBAPI>()
                                                      .setEnvMode(envType: EnvType.Test);
                                                  userManager.reload();
                                                  Navigator.of(context).pop();
                                                },
                                                isDestructiveAction:
                                                    locator.get<SharedPref>().getEnvType() ==
                                                        EnvType.Test,
                                              ),
                                              CupertinoActionSheetAction(
                                                child: Text("DEV"),
                                                onPressed: () async {
                                                  await locator
                                                      .get<BBBAPI>()
                                                      .setEnvMode(envType: EnvType.Dev);
                                                  userManager.reload();
                                                  Navigator.of(context).pop();
                                                },
                                                isDestructiveAction:
                                                    locator.get<SharedPref>().getEnvType() ==
                                                        EnvType.Dev,
                                              )
                                            ],
                                            cancelButton: CupertinoActionSheetAction(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(I18n.of(context).dialogCancelButton)),
                                          );
                                        });
                                  },
                                )
                              : Container()
                        ],
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: userManager.user != null && userManager.user.logined,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        if (userManager.user.testAccountResponseModel != null) {
                          showFlashBar(context, false, content: I18n.of(context).changeFromTryEnv,
                              callback: () async {
                            await userManager.logoutTestAccount();
                            locator.get<AccountViewModel>().checkRewardAccount(
                                accountName: userManager.user.name, bonusEvent: true);
                            Navigator.of(context).maybePop();
                          });
                        } else {
                          if (userManager.user.loginType == LoginType.reward) {
                            showFlashBar(context, false, content: I18n.of(context).quitReward,
                                callback: () async {
                              await userManager.logOutRewardAccount();
                              locator.get<AccountViewModel>().checkRewardAccount(
                                  accountName: userManager.user.name, bonusEvent: true);
                              Navigator.of(context).maybePop();
                            });
                          } else {
                            userManager.logout();
                            Navigator.pop(context);
                          }
                        }
                      },
                      child: Container(
                          width: 275,
                          height: 47,
                          margin: EdgeInsets.only(bottom: 50),
                          child: Center(
                            child: userManager.user.testAccountResponseModel != null
                                ? Text(I18n.of(context).clickToQuit,
                                    style: StyleNewFactory.yellowOrange18)
                                : (userManager.user.loginType == LoginType.reward
                                    ? Text(I18n.of(context).quitReward,
                                        style: StyleNewFactory.yellowOrange18)
                                    : Text(I18n.of(context).logout,
                                        style: StyleNewFactory.yellowOrange18)),
                          ),
                          decoration: new BoxDecoration(
                              border: Border.all(color: Palette.appYellowOrange, width: 1),
                              borderRadius: BorderRadius.circular(5))),
                    ),
                  ),
                )
              ],
            );
          },
        ));
  }

  _checkConfiguretion() async {
    await locator.get<ConfigureApi>().getUpdateInfo(isIOS: Platform.isIOS);

    UpdateResponse updateResponse = locator.get<ConfigureApi>().updateResponse;
    bool isForce = updateResponse.isForceUpdate(locator.get<PackageInfo>().version);
    if (updateResponse.needUpdate(locator.get<PackageInfo>().version)) {
      showDialog(
          barrierDismissible: !isForce,
          context: context,
          builder: (context) {
            return DialogFactory.normalConfirmDialog(context,
                title: I18n.of(context).updateTitle,
                isForce: isForce,
                content: updateResponse.cnUpdateInfo, onConfirmPressed: () {
              launchURL(url: updateResponse.url);
              if (!isForce) {
                Navigator.of(context, rootNavigator: true).pop();
              }
            });
          });
    } else {
      showNotification(context, false, "当前为最新版本", callback: () {});
    }
  }
}

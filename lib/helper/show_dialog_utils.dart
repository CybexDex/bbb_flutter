import 'package:bbb_flutter/cache/shared_pref.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/entity/user_biometric_entity.dart';
import 'package:bbb_flutter/models/response/activities_response.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api.dart';
import 'package:bbb_flutter/services/network/configure/configure_api.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:cybex_flutter_plugin/cybex_flutter_plugin.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:oktoast/oktoast.dart';
import 'package:url_launcher/url_launcher.dart';

void showNotification(BuildContext context, bool isFaild, String content, {Function callback}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context)?.maybePop();
        });
        return isFaild
            ? DialogFactory.failDialog(context, content: content)
            : DialogFactory.successDialog(context, content: content);
      }).then((value) {
    if (callback != null) {
      callback();
    }
  });
}

showLoading(BuildContext context, {bool isBarrierDismissible}) {
  showGeneralDialog(
    context: context,
    pageBuilder: (context, animate1, animate2) {
      return Center(
        child: SpinKitWave(
          color: Palette.redOrange,
          size: 30,
        ),
      );
    },
    barrierDismissible: isBarrierDismissible ?? true,
    barrierLabel: "dd",
    barrierColor: Colors.white10,
    transitionDuration: const Duration(milliseconds: 10),
  );
}

checkAdd(BuildContext context, int type) async {
  await locator.get<ConfigureApi>().getActivities();
  ActivitiesResponse response = locator.get<ConfigureApi>().activitiesResponseList[type];
  if (response.showstaus == 0 ||
      (locator.get<UserManager>().user.logined && response.showstaus == 1) ||
      (!locator.get<UserManager>().user.logined && response.showstaus == 2)) {
    if (response.enable &&
        (locator.get<SharedPref>().getActivityResponse(name: response.name)?.image !=
                response.image ||
            locator.get<SharedPref>().getActivityResponse(name: response.name)?.url !=
                response.url)) {
      await locator.get<SharedPref>().saveActivitiesResponse(activitiesResponse: response);
      Future.delayed(Duration.zero, () {
        showDialog(
            barrierDismissible: true,
            context: context,
            builder: (context) {
              return DialogFactory.addsDialog(context, url: response.url, img: response.image,
                  onImageTap: () {
                if (response.url == null || response.url.isEmpty) {
                  return;
                }
                if (response.url.contains(HTTPString)) {
                  launchURL(url: Uri.encodeFull(response.url));
                } else {
                  Navigator.of(context).pushNamed(response.url);
                }
              });
            });
      });
    }
  }
}

launchURL({String url}) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Widget showFlashBar(BuildContext context, bool isFaild, {String content, Function callback}) {
  return Flushbar(
    flushbarStyle: FlushbarStyle.FLOATING,
    flushbarPosition: FlushbarPosition.TOP,
    icon: isFaild ? Image.asset(R.resAssetsIconsIcFail) : Image.asset(R.resAssetsIconsIcSuccess),
    messageText: Text(
      content,
      style: StyleNewFactory.black15,
    ),
    backgroundColor: Colors.white,
    borderRadius: 8,
    boxShadows: [StyleFactory.shadow],
    margin: EdgeInsets.all(8),
    duration: Duration(seconds: 3),
    onStatusChanged: (status) {
      if (status == FlushbarStatus.DISMISSED) {
        if (callback == null) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      } else if (status == FlushbarStatus.SHOWING) {
        if (callback != null) {
          callback();
        }
      }
    },
  )..show(context);
}

void showThemeToast(String message) {
  showToastWidget(Container(
    decoration:
        BoxDecoration(color: Colors.black.withOpacity(0.7), borderRadius: BorderRadius.circular(5)),
    height: ScreenUtil.getInstance().setWidth(120),
    width: ScreenUtil.getInstance().setWidth(120),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.check, color: Colors.white, size: ScreenUtil.getInstance().setHeight(50)),
        Text(
          message,
          style: StyleNewFactory.white18,
        )
      ],
    ),
  ));
}

showUnlockAndBiometricDialog(
    {BuildContext context, TextEditingController passwordEditor, VoidCallback callback}) async {
  UserBiometricEntity userBiometricEntity = locator
      .get<SharedPref>()
      .getUserBiometricEntity(userName: locator.get<UserManager>().user.name);
  if (locator.get<UserManager>().user.isLocked) {
    try {
      if (userBiometricEntity?.isBiomtricOpen ?? false) {
        String privateKey = await locator
            .get<FlutterSecureStorage>()
            .read(key: locator.get<UserManager>().user.name);
        if (privateKey == null) {
          showDialog(
              context: context,
              builder: (context) {
                return KeyboardAvoider(
                  child: DialogFactory.unlockDialog(context, controller: passwordEditor),
                  autoScroll: true,
                );
              }).then((value) {
            if (value) {
              callback();
            }
          });
        } else {
          locator.get<UserManager>().user.privateKey = privateKey;
          await CybexFlutterPlugin.setDefaultPrivKey(privateKey);
          locator.get<UserManager>().user.userPrivateKeyTag = "used";
          if (!locator.get<UserManager>().hasRegisterPush) {
            int expir = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
            int timeout = expir + 5 * 60;

            locator.get<BBBAPI>().registerPush(
                regId: locator.get<RefManager>().pushRegId,
                accountName: locator.get<UserManager>().user.account.name,
                timeout: timeout);
          }
          callback();
        }
        // try {
        // } on PlatformException catch (error) {
        //   print(error.code);
        //   if (error.code == notEnrolled || error.code == passcodeNotSet) {
        //     showDialog(
        //         context: context,
        //         builder: (context) {
        //           return KeyboardAvoider(
        //             child: DialogFactory.unlockDialog(context, controller: passwordEditor),
        //             autoScroll: true,
        //           );
        //         }).then((value) {
        //       if (value) {
        //         callback();
        //       }
        //     });
        //   }
        // }
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return KeyboardAvoider(
                child: DialogFactory.unlockDialog(context, controller: passwordEditor),
                autoScroll: true,
              );
            }).then((value) {
          if (value) {
            callback();
          }
        });
      }
    } on PlatformException catch (e) {
      if (e.code == "negativeButton") {
        print(e.message);
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return KeyboardAvoider(
                child: DialogFactory.unlockDialog(context, controller: passwordEditor),
                autoScroll: true,
              );
            }).then((value) {
          if (value) {
            callback();
          }
        });
        if (e.details.toString().contains("KeyPermanentlyInvalidatedException") ||
            e.code == "No Biometric") {
          userBiometricEntity.isBiomtricOpen = false;
          locator
              .get<SharedPref>()
              .saveUserBiometricEntity(userBiometricEntity: userBiometricEntity);
        }
      }
    }
  } else {
    if (locator.get<UserManager>().user.testAccountResponseModel != null) {
      CybexFlutterPlugin.setDefaultPrivKey(
          locator.get<UserManager>().user.testAccountResponseModel.privkey);
    }
    if (locator.get<UserManager>().user.keys == null) {
      await CybexFlutterPlugin.setDefaultPrivKey(locator.get<UserManager>().user.privateKey);
    }
    callback();
  }
}

checkIfShowReminderDialog(UserBiometricEntity userBiometricEntity, BuildContext context,
    TextEditingController controller) {
  int count = 0;
  if (DateTime.now().toUtc().millisecondsSinceEpoch - userBiometricEntity.timeStamp >
      1000 * 60 * 60 * 72) {
    showDialog(
        context: context,
        builder: (context) {
          return DialogFactory.unlockDialog(context,
              controller: controller,
              contentText: "为避免您遗忘密码，我们会定期提醒您进行验证", onConfirmPressed: (model) async {
            bool result = await model.checkPassword(
                name: locator.get<UserManager>().user.name, password: controller.text);
            if (result) {
              userBiometricEntity.timeStamp = DateTime.now().toUtc().millisecondsSinceEpoch;
              locator
                  .get<SharedPref>()
                  .saveUserBiometricEntity(userBiometricEntity: userBiometricEntity);
              Navigator.of(context, rootNavigator: true).popUntil((route) => route.isFirst);
            } else {
              count++;
              if (count > 3) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return DialogFactory.normalConfirmDialog(context,
                          title: "提示",
                          isForce: true,
                          content: "若您忘记密码，建议将资产转移至其他账户", onConfirmPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      });
                    });
              }
            }
          });
        });
  }
}

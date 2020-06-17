import 'dart:io';

import 'package:bbb_flutter/base/base_model.dart';
import 'package:bbb_flutter/cache/shared_pref.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/entity/user_biometric_entity.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/error_codes.dart';
import 'package:local_auth/local_auth.dart';
import 'package:oktoast/oktoast.dart';

class BiometricManager extends BaseModel {
  final LocalAuthentication _authentication;
  bool canCheckBiometrics = false;
  bool isOpen;
  List<BiometricType> availableBiometrics = [];
  String type = " ";
  bool needwriteToStore = false;

  final SharedPref _sharedPref;

  BiometricManager({LocalAuthentication localAuthentication, SharedPref sharedPref})
      : _authentication = localAuthentication,
        _sharedPref = sharedPref;

  checkBiometrics() async {
    isOpen = _sharedPref
        .getUserBiometricEntity(userName: locator.get<UserManager>().user.name)
        .isBiomtricOpen;
    canCheckBiometrics = await _authentication.canCheckBiometrics;
    setBusy(false);
  }

  // checkAvailability() async {
  //   print("000000000000-------------------");
  //   print(_sharedPref.isBiometric());
  //   setBusy(false);
  // }

  getAvailableBiometrics() async {
    try {
      availableBiometrics = await _authentication.getAvailableBiometrics();
      if (availableBiometrics.isEmpty) {
        if (Platform.isIOS) {
          DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
          IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          _getIosModelVersion(iosInfo.utsname.machine);
        }
      } else {
        _getType(availableBiometrics);
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  _getType(List<BiometricType> types) {
    if (types.contains(BiometricType.face)) {
      type = "面容解锁";
    } else if (types.contains(BiometricType.fingerprint)) {
      type = "指纹解锁";
    }
    setBusy(false);
  }

  _getIosModelVersion(String iphone) {
    var escapedMechineCode = iphone.replaceAll(",", "");
    var versionNumber =
        int.tryParse(escapedMechineCode.substring(escapedMechineCode.lastIndexOf("iPhone") + 6));
    if (versionNumber > 105 || versionNumber == 103) {
      type = "面容解锁";
      canCheckBiometrics = true;
    } else if (versionNumber >= 61 && versionNumber <= 105) {
      type = "指纹解锁";
      canCheckBiometrics = true;
    } else {
      canCheckBiometrics = false;
    }
    setBusy(false);
  }

  Future<bool> authenticate({bool useErrorDialog}) {
    try {
      return _authentication.authenticateWithBiometrics(
          localizedReason: "请验证",
          iOSAuthStrings: IOSAuthMessages(
              goToSettingsDescription: "尚未开启面容ID(指纹)功能，请前往系统设置",
              goToSettingsButton: "前往设置",
              cancelButton: "关闭"),
          useErrorDialogs: useErrorDialog);
    } on PlatformException catch (error) {
      throw error;
    }
  }

  switchOn(bool value, BuildContext context, TextEditingController controller) async {
    if (availableBiometrics.isEmpty) {
      authenticate(useErrorDialog: true);
    } else {
      if (value) {
        showDialog(
            context: context,
            builder: (context) {
              return DialogFactory.unlockDialog(context, controller: controller);
            }).then((back) async {
          if (back != null && back) {
            if (availableBiometrics.isNotEmpty) {
              try {
                if ((Platform.isIOS &&
                        await locator
                                .get<FlutterSecureStorage>()
                                .contain(key: locator.get<UserManager>().user.name) !=
                            "true") ||
                    Platform.isAndroid) {
                  await locator.get<FlutterSecureStorage>().write(
                      key: locator.get<UserManager>().user.name,
                      value: locator.get<UserManager>().user.keys.activeKey.privateKey);
                  locator.get<UserManager>().user.privateKey =
                      locator.get<UserManager>().user.keys.activeKey.privateKey;
                }
                UserBiometricEntity userBiometricEntity = UserBiometricEntity(
                    isBiomtricOpen: value,
                    userName: locator.get<UserManager>().user.name,
                    timeStamp: DateTime.now().toUtc().millisecondsSinceEpoch);
                _sharedPref.saveUserBiometricEntity(userBiometricEntity: userBiometricEntity);
                isOpen = value;
                setBusy(false);
                Navigator.of(context).pop();
              } on PlatformException catch (e) {
                print(e);
                if (e.code == lockedOut) {
                  showToast("已锁定，30s后再试", textPadding: EdgeInsets.all(20));
                }
                return;
              }
            }
          }
        });
      } else {
        needwriteToStore = false;
        UserBiometricEntity userBiometricEntity =
            _sharedPref.getUserBiometricEntity(userName: locator.get<UserManager>().user.name);
        userBiometricEntity.isBiomtricOpen = value;
        _sharedPref.saveUserBiometricEntity(userBiometricEntity: userBiometricEntity);
        isOpen = value;
        locator.get<FlutterSecureStorage>().deleteAll();
      }
      setBusy(false);
    }
  }
}

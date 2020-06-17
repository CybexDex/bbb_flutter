import 'package:bbb_flutter/manager/biomeric_manager.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/ui_common.dart';

class FingerPrintReminderPage extends StatefulWidget {
  FingerPrintReminderPage({Key key}) : super(key: key);

  @override
  State<FingerPrintReminderPage> createState() {
    return FingerPrintReminderState();
  }
}

class FingerPrintReminderState extends State<FingerPrintReminderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Palette.backButtonColor, //change your color here
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          elevation: 0,
        ),
        body: Align(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(10)),
                  child: Icon(
                    Icons.info_outline,
                    size: ScreenUtil.getInstance().setWidth(80),
                  )),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(0),
              ),
              Container(
                margin: EdgeInsets.only(
                    right: ScreenUtil.getInstance().setWidth(20),
                    left: ScreenUtil.getInstance().setWidth(20)),
                alignment: Alignment.center,
                child: Text(
                  "指纹（面容）识别解锁注意事项",
                  style: StyleNewFactory.black18,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: ScreenUtil.getInstance().setWidth(20),
                    right: ScreenUtil.getInstance().setWidth(20),
                    left: ScreenUtil.getInstance().setWidth(20)),
                alignment: Alignment.center,
                child: Text(
                  "指纹（面容）识别使用了设备生物识别技术进行确认使用者是否为设备拥有者，并且使用生物特性进行加密存储，除了设备拥有者，没有其他任何人可以取出密码。",
                  style: StyleNewFactory.grey12Opacity60,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: ScreenUtil.getInstance().setWidth(20),
                    right: ScreenUtil.getInstance().setWidth(20),
                    left: ScreenUtil.getInstance().setWidth(20)),
                alignment: Alignment.centerLeft,
                child: Text(
                  "使用指纹（面容）识别解锁，请您确保以下注意事项:",
                  style: StyleNewFactory.black12,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: ScreenUtil.getInstance().setWidth(10),
                    right: ScreenUtil.getInstance().setWidth(20),
                    left: ScreenUtil.getInstance().setWidth(20)),
                alignment: Alignment.centerLeft,
                child: Text(
                  "● 请确认密码已妥善保存，遗失密码将不可找回",
                  style: StyleNewFactory.red12,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: ScreenUtil.getInstance().setWidth(10),
                    right: ScreenUtil.getInstance().setWidth(20),
                    left: ScreenUtil.getInstance().setWidth(20)),
                alignment: Alignment.centerLeft,
                child: Text(
                  "● 请勿在root或越狱设备使用该功能",
                  style: StyleNewFactory.red12,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: ScreenUtil.getInstance().setWidth(10),
                    right: ScreenUtil.getInstance().setWidth(20),
                    left: ScreenUtil.getInstance().setWidth(20)),
                alignment: Alignment.centerLeft,
                child: Text(
                  "● 请勿在自己手机添加他人指纹或面容识别",
                  style: StyleNewFactory.red12,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: ScreenUtil.getInstance().setWidth(10),
                    right: ScreenUtil.getInstance().setWidth(20),
                    left: ScreenUtil.getInstance().setWidth(20)),
                alignment: Alignment.centerLeft,
                child: Text(
                  "● 请勿将手机开启密码告诉他人",
                  style: StyleNewFactory.red12,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: ScreenUtil.getInstance().setWidth(10),
                    right: ScreenUtil.getInstance().setWidth(20),
                    left: ScreenUtil.getInstance().setWidth(20)),
                alignment: Alignment.centerLeft,
                child: Text(
                  "● 请勿将手机交给他人",
                  style: StyleNewFactory.red12,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: ScreenUtil.getInstance().setWidth(10),
                    right: ScreenUtil.getInstance().setWidth(20),
                    left: ScreenUtil.getInstance().setWidth(20)),
                alignment: Alignment.centerLeft,
                child: Text(
                  "● 增加或删除手机指纹后App需要重新开启指纹解锁",
                  style: StyleNewFactory.red12,
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    right: ScreenUtil.getInstance().setWidth(20),
                    left: ScreenUtil.getInstance().setWidth(20),
                    bottom: ScreenUtil.getInstance().setHeight(15),
                    top: ScreenUtil.getInstance().setHeight(20)),
                child: WidgetFactory.button(
                    color: Palette.appYellowOrange,
                    data: "开启指纹/面容解锁",
                    topPadding: ScreenUtil.getInstance().setHeight(10),
                    bottomPadding: ScreenUtil.getInstance().setHeight(10),
                    onPressed: () async {
                      TextEditingController controller = TextEditingController();
                      locator.get<BiometricManager>().getAvailableBiometrics();
                      await locator.get<BiometricManager>().switchOn(true, context, controller);
                    }),
              )
            ],
          ),
        ));
  }
}

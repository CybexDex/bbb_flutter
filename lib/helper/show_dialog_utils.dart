import 'package:bbb_flutter/cache/shared_pref.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/activities_response.dart';
import 'package:bbb_flutter/services/network/configure/configure_api.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';

void showNotification(BuildContext context, bool isFaild, String content,
    {Function callback}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context)?.pop();
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
          size: 50,
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
  ActivitiesResponse response =
      locator.get<ConfigureApi>().activitiesResponseList[type];
  if (response.showstaus == 0 ||
      (locator.get<UserManager>().user.logined && response.showstaus == 1) ||
      (!locator.get<UserManager>().user.logined && response.showstaus == 2)) {
    if (response.enable &&
        (locator
                    .get<SharedPref>()
                    .getActivityResponse(name: response.name)
                    ?.image !=
                response.image ||
            locator
                    .get<SharedPref>()
                    .getActivityResponse(name: response.name)
                    ?.url !=
                response.url)) {
      await locator
          .get<SharedPref>()
          .saveActivitiesResponse(activitiesResponse: response);
      Future.delayed(Duration.zero, () {
        showDialog(
            barrierDismissible: true,
            context: context,
            builder: (context) {
              return DialogFactory.addsDialog(context,
                  url: response.url, img: response.image, onImageTap: () {
                if (response.url.contains("https")) {
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

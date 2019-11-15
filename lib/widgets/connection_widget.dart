import 'dart:async';

import 'package:bbb_flutter/manager/market_manager.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:connectivity/connectivity.dart';
import 'package:oktoast/oktoast.dart';

class ConnectionWidget extends StatefulWidget {
  final Widget child;
  ConnectionWidget({Key key, this.child}) : super(key: key);

  @override
  _ConnectionWidgetState createState() => _ConnectionWidgetState();
}

class _ConnectionWidgetState extends State<ConnectionWidget> {
  StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.wifi) {
        Future.delayed(Duration.zero, () {
          showToast(
            I18n.of(globalKey.currentContext).connectToWifi,
            duration: Duration(seconds: 5),
            position: ToastPosition.bottom,
            backgroundColor: Colors.black.withOpacity(0.8),
            radius: 13.0,
            textStyle: TextStyle(fontSize: 18.0),
          );
        });
        locator.get<MarketManager>().cancelAndRemoveData();
        locator.get<MarketManager>().loadAllData("BXBT");
      } else if (result == ConnectivityResult.mobile) {
        Future.delayed(Duration.zero, () {
          showToast(
            I18n.of(globalKey.currentContext).connectToMobile,
            duration: Duration(seconds: 5),
            position: ToastPosition.bottom,
            backgroundColor: Colors.black.withOpacity(0.8),
            radius: 13.0,
            textStyle: TextStyle(fontSize: 18.0),
          );
        });

        locator.get<MarketManager>().cancelAndRemoveData();
        locator.get<MarketManager>().loadAllData("BXBT");
      } else {
        Future.delayed(Duration.zero, () {
          showToast(
            I18n.of(globalKey.currentContext).noConnection,
            duration: Duration(seconds: 5),
            position: ToastPosition.bottom,
            backgroundColor: Colors.black.withOpacity(0.8),
            radius: 13.0,
            textStyle: TextStyle(fontSize: 18.0),
          );
        });
      }
    });
  }

  void checkConnection(BuildContext context) {}

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

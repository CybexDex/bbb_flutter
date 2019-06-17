import 'package:bbb_flutter/blocs/bloc_refData.dart';
import 'package:bbb_flutter/blocs/market_history_bloc.dart';
import 'package:bbb_flutter/blocs/user_bloc.dart';
import 'package:bbb_flutter/colors/palette.dart';
import 'package:bbb_flutter/common/decoration_factory.dart';
import 'package:bbb_flutter/models/response/web_socket_n_x_price_response_entity.dart';
import 'package:bbb_flutter/shared_pref.dart';
import 'package:bbb_flutter/websocket/websocket_bloc.dart';
import 'package:bbb_flutter/widgets/sparkline.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InjectorWidget extends InheritedWidget {
  final UserBloc userBloc = UserBloc();
  final RefDataBloc refDataBloc = RefDataBloc();
  final MarketHistoryBloc marketHistoryBloc = MarketHistoryBloc();

  List<TickerData> _listTickerData = [];
  Widget exchangeWidget;

  init() async {
    SharedPref().prefs = await SharedPreferences.getInstance();
    userBloc.refreshUserInfo();

    exchangeWidget = StreamBuilder<WebSocketNXPriceResponseEntity>(
        stream: WebSocketBloc().getNXPriceBloc.stream,
        builder: (context, wbSnapshot) {
          if (wbSnapshot == null || !wbSnapshot.hasData) {
            return Container();
          }
          var wbResponse = wbSnapshot.data;
          return Expanded(
              child: Container(
            decoration: DecorationFactory.cornerShadowDecoration,
            height: double.infinity,
            margin: EdgeInsets.only(top: 1, left: 0, right: 0),
            child: Container(
                child: StreamBuilder<List<TickerData>>(
              builder: (context, snapshot) {
                if (snapshot == null || !snapshot.hasData) {
                  return Container();
                }
                List<TickerData> response = snapshot.data;
                _listTickerData.addAll(response);
                return Sparkline(
                  data: _listTickerData
                    ..add(TickerData(
                        wbResponse.px, DateTime.parse(wbResponse.time))),
                  suppleData: SuppleData(
                      stopTime: DateTime.now().add(Duration(minutes: 2)),
                      endTime: DateTime.now().add(Duration(minutes: 12)),
                      cutOff: 1.7,
                      takeProfit: 7.8,
                      underOrder: 4.5,
                      current: 6.0),
                  startTime: DateTime.now().subtract(Duration(minutes: 15)),
                  startLineOfTime:
                      DateTime.now().subtract(Duration(minutes: 15)),
                  endTime: DateTime.now().add(Duration(minutes: 15)),
                  lineColor: Palette.darkSkyBlue,
                  lineWidth: 2,
                  gridLineWidth: 0.5,
                  fillGradient: LinearGradient(colors: [
                    Palette.darkSkyBlue.withAlpha(100),
                    Palette.darkSkyBlue.withAlpha(0)
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                  gridLineColor: Palette.veryLightPinkTwo,
                  pointSize: 8.0,
                  pointColor: Palette.darkSkyBlue,
                );
              },
              stream: marketHistoryBloc.marketHistorySubject.stream,
            )),
          ));
        });
  }

  InjectorWidget({
    Key key,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  static InjectorWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(InjectorWidget)
        as InjectorWidget;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}

import 'package:bbb_flutter/models/response/websocket_nx_daily_px_response.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/sparkline.dart';

class ExchangeHeader extends StatefulWidget {
  ExchangeHeader({Key key}) : super(key: key);

  @override
  ExchangeHeaderState createState() => ExchangeHeaderState();
}

class ExchangeHeaderState extends State<ExchangeHeader> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<TickerData, WebSocketNXDailyPxResponse>(
        builder: (context, data, dailyPx, child) {
      double percentage = (data != null && dailyPx != null)
          ? (((data.value - dailyPx.lastDayPx) / dailyPx.lastDayPx) * 100)
          : 0;
      return Container(
        padding: EdgeInsets.fromLTRB(14, 0, 14, 7),
        width: ScreenUtil.screenWidth,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(data?.value?.toStringAsFixed(4) ?? "--",
                    style: TextStyle(
                      fontFamily: 'PingFangSC',
                      color: percentage >= 0
                          ? Palette.redOrange
                          : Palette.shamrockGreen,
                      fontSize: ScreenUtil.getInstance().setSp(24),
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0,
                    )),
                Icon(
                    percentage >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                    color: percentage >= 0
                        ? Palette.redOrange
                        : Palette.shamrockGreen),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(I18n.of(context).exchangeChangeRatio,
                        style: StyleNewFactory.grey9),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                        percentage == 0
                            ? "--"
                            : "${percentage.toStringAsFixed(2)}%",
                        style: TextStyle(
                          fontFamily: 'PingFangSC',
                          color: percentage >= 0
                              ? Palette.redOrange
                              : Palette.shamrockGreen,
                          fontSize: Dimen.fontSize10,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                        ))
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(I18n.of(context).exchange24High,
                        style: StyleNewFactory.grey9),
                    SizedBox(
                      width: 10,
                    ),
                    Text(dailyPx?.highPx?.toStringAsFixed(2) ?? "--",
                        style: StyleNewFactory.grey10)
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(I18n.of(context).exchange24Low,
                        style: StyleNewFactory.grey9),
                    SizedBox(
                      width: 10,
                    ),
                    Text(dailyPx?.lowPx?.toStringAsFixed(2) ?? "--",
                        style: StyleNewFactory.grey10)
                  ],
                )
              ],
            )
          ],
        ),
      );
    });
  }
}

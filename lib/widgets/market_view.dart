import 'package:bbb_flutter/manager/market_manager.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/sparkline.dart';

class MarketView extends StatelessWidget {
  const MarketView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<List<TickerData>>(
      builder: (context, data, child) {
        locator.get<Log>().printWrapped("tttttttttttt");
        return data == null
            ? Container()
            : Expanded(
                child: Container(
                    decoration: DecorationFactory.cornerShadowDecoration,
                    height: double.infinity,
                    margin: EdgeInsets.only(top: 1, left: 0, right: 0),
                    child: Sparkline(
                      data: data,
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
                      fillGradient: LinearGradient(
                          colors: [
                            Palette.darkSkyBlue.withAlpha(100),
                            Palette.darkSkyBlue.withAlpha(0)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                      gridLineColor: Palette.veryLightPinkTwo,
                      pointSize: 8.0,
                      pointColor: Palette.darkSkyBlue,
                    )));
      },
    );
  }
}

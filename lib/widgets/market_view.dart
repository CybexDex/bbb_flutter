import 'dart:async';

import 'package:bbb_flutter/helper/common_utils.dart';
import 'package:bbb_flutter/logic/market_vm.dart';
import 'package:bbb_flutter/logic/order_vm.dart';
import 'package:bbb_flutter/logic/trade_vm.dart';
import 'package:bbb_flutter/manager/market_manager.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/sparkline.dart';
import 'package:logger/logger.dart';

class MarketView extends StatelessWidget {
  final double width;
  final bool isTrade;
  const MarketView({Key key, this.width, this.isTrade}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OrderViewModel order;
    TradeViewModel trade;

    if (isTrade) {
      trade = Provider.of<TradeViewModel>(context);
    } else {
      order = Provider.of<OrderViewModel>(context);
    }

    return Consumer2<List<TickerData>, TickerData>(
      builder: (context, data, last, child) {
        if (data == null) {
          return Container();
        }
        var klines = data;
        if (!isAllEmpty(data) && (data.last.time.minute == last.time.minute)) {
          klines.removeLast();
          klines.add(last);
        } else {
          klines.add(last);
        }
        // locator.get<Logger>().finest(last.value);

        return BaseWidget<MarketViewModel>(
          model: MarketViewModel(),
          onModelReady: (model) {
            model.seedToCurrent();
          },
          builder: (context, model, child) {
            if (order != null) {
              model.supplyDataWithTrade(data, order.getCurrentOrder());
            }

            if (trade != null) {
              model.supplyDataWithOrder(
                  data, trade.orderForm, trade.contract.strikeLevel);
            }

            return Container(
                decoration: DecorationFactory.cornerShadowDecoration,
                height: double.infinity,
                margin: EdgeInsets.only(top: 1, left: 0, right: 0),
                child: GestureDetector(
                  onPanStart: (details) {
                    model.lastOffset = details.globalPosition;
                  },
                  onPanUpdate: (details) {
                    double gap =
                        details.globalPosition.dx - model.lastOffset.dx;

                    double timeOffset = 1800 * gap / ScreenUtil.screenWidthDp;
                    model.lastOffset = details.globalPosition;

                    var start = model.startTime
                        .subtract(Duration(seconds: timeOffset.toInt()));
                    var end = model.endTime
                        .subtract(Duration(seconds: timeOffset.toInt()));
                    if (end.compareTo(
                            DateTime.now().add(Duration(minutes: 15))) >
                        0) {
                      return;
                    }
                    if (start.compareTo(data.first.time) <= 0) {
                      return;
                    }
                    model.changeScope(start, end);
                  },
                  child: Sparkline(
                    data: klines,
                    suppleData: model.suppleData,
                    startTime: model.startTime,
                    endTime: model.endTime,
                    lineColor: Palette.darkSkyBlue,
                    timeLineGap: Duration(seconds: 300),
                    lineWidth: 2,
                    gridLineWidth: 0.5,
                    width: width,
                    fillGradient: LinearGradient(colors: [
                      Palette.darkSkyBlue.withAlpha(100),
                      Palette.darkSkyBlue.withAlpha(0)
                    ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                    gridLineColor: Palette.veryLightPinkTwo,
                    pointSize: 8.0,
                    pointColor: Palette.darkSkyBlue,
                    repaint: model,
                  ),
                ));
          },
        );
      },
    );
  }
}

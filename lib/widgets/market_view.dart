import 'package:bbb_flutter/helper/time_duration_calculate_helper.dart';
import 'package:bbb_flutter/logic/limit_order_vm.dart';
import 'package:bbb_flutter/logic/market_vm.dart';
import 'package:bbb_flutter/logic/order_vm.dart';
import 'package:bbb_flutter/logic/trade_vm.dart';
import 'package:bbb_flutter/manager/market_manager.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/k_line/entity/k_line_entity.dart';
import 'package:bbb_flutter/widgets/sparkline.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'k_line/k_chart_widget.dart';

class MarketView extends StatefulWidget {
  final double width;
  final bool isTrade;
  final MarketManager mtm;
  const MarketView({Key key, this.width, this.isTrade, this.mtm})
      : super(key: key);

  @override
  _MarketViewState createState() => _MarketViewState();
}

class _MarketViewState extends State<MarketView> with WidgetsBindingObserver {
  var initModel;
  @override
  void initState() {
    initModel = MarketViewModel(mtm: widget.mtm, bbbapi: locator.get());
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        locator.get<MarketManager>().cancelAndRemoveData();
        break;
      case AppLifecycleState.suspending:
        break;
      case AppLifecycleState.resumed:
        locator.get<MarketManager>().loadAllData(null);
        initModel.seedToCurrent();
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    OrderViewModel order;
    TradeViewModel trade;
    LimitOrderViewModel limitOrder;

    if (widget.isTrade != null) {
      if (widget.isTrade) {
        trade = Provider.of<TradeViewModel>(context);
      } else {
        order = Provider.of<OrderViewModel>(context);
      }
    } else {
      limitOrder = Provider.of<LimitOrderViewModel>(context);
    }

    return Consumer3<List<TickerData>, TickerData, List<KLineEntity>>(
      builder: (context, data, last, kline, child) {
        if (data == null) {
          return SpinKitWave(
            color: Palette.redOrange,
            size: 20,
          );
        }
        // var klines = data;
        // if (!isAllEmpty(data) && (data.last.time.minute == last.time.minute)) {
        //   klines.removeLast();
        //   klines.add(last);
        // } else {
        //   if (last != null) {
        //     klines.add(last);
        //   }
        // }
        // print(data.last.value);
        // print("kline${klines.last.value}");

        return BaseWidget<MarketViewModel>(
          model: initModel,
          onModelReady: (model) {
            // model.changeDuration(MarketDuration.oneMin);
            model.seedToCurrent();
          },
          builder: (context, model, child) {
            if (order != null) {
              final orderModel = order.getCurrentOrder();
              if (orderModel != null) {
                model.supplyDataWithTrade(data, order, true);
              } else {
                model.supplyDataWithTrade(data, order, false);
              }
            }

            if (trade != null) {
              model.supplyDataWithOrder(
                  data, trade.orderForm, trade.contract.strikeLevel);
            }

            if (limitOrder != null) {
              model.supplyDataWithLimitOrder(data, limitOrder.orderForm);
            }

            return Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 22,
                    alignment: Alignment.topLeft,
                    child: order != null
                        ? DefaultTabController(
                            length: 5,
                            child: TabBar(
                              isScrollable: true,
                              labelStyle: StyleFactory.buySellExplainText,
                              indicatorWeight: 0.5,
                              indicatorSize: TabBarIndicatorSize.label,
                              indicatorColor: Palette.subTitleColor,
                              unselectedLabelColor: Palette.descColor,
                              labelColor: Palette.subTitleColor,
                              indicator: UnderlineTabIndicator(
                                borderSide: BorderSide(
                                    color: Palette.invitePromotionBadgeColor,
                                    width: 2),
                                insets: EdgeInsets.fromLTRB(0, 0.0, 0, 3),
                              ),
                              tabs: [
                                Tab(
                                  text: I18n.of(context).line,
                                ),
                                Tab(
                                  text: I18n.of(context).oneMin,
                                ),
                                Tab(text: I18n.of(context).fiveMin),
                                Tab(
                                  text: I18n.of(context).oneHour,
                                ),
                                Tab(
                                  text: I18n.of(context).oneDay,
                                ),
                              ],
                              onTap: (index) {
                                switch (index) {
                                  case 0:
                                    model.changeDuration(MarketDuration.line);
                                    break;
                                  case 1:
                                    model.changeDuration(MarketDuration.oneMin,
                                        time:
                                            last.time.millisecondsSinceEpoch ~/
                                                1000);
                                    break;
                                  case 2:
                                    model.changeDuration(MarketDuration.fiveMin,
                                        time:
                                            last.time.millisecondsSinceEpoch ~/
                                                1000);
                                    break;
                                  case 3:
                                    model.changeDuration(MarketDuration.oneHour,
                                        time:
                                            last.time.millisecondsSinceEpoch ~/
                                                1000);
                                    break;
                                  case 4:
                                    model.changeDuration(MarketDuration.oneDay,
                                        time:
                                            last.time.millisecondsSinceEpoch ~/
                                                1000);
                                    break;
                                  default:
                                    model.changeDuration(MarketDuration.line);
                                }
                              },
                            ),
                          )
                        : Container(),
                  ),
                  Flexible(
                    flex: 20,
                    child: Container(
                        height: double.infinity,
                        margin: EdgeInsets.only(top: 1, left: 0, right: 0),
                        child: model.isline
                            ? GestureDetector(
                                onPanStart: (details) {
                                  model.lastOffset = details.globalPosition;
                                },
                                onPanUpdate: (details) {
                                  double gap = details.globalPosition.dx -
                                      model.lastOffset.dx;

                                  double timeOffset = 30 *
                                      marketDurationSecondMap[
                                          model.marketDuration] *
                                      gap /
                                      ScreenUtil.screenWidthDp;
                                  model.lastOffset = details.globalPosition;

                                  var start = model.startTime.subtract(
                                      Duration(seconds: timeOffset.toInt()));
                                  var end = model.endTime.subtract(
                                      Duration(seconds: timeOffset.toInt()));
                                  if (end.compareTo(getCorrectTime().add(
                                          Duration(
                                              seconds: 10 *
                                                  marketDurationSecondMap[
                                                      model.marketDuration]))) >
                                      0) {
                                    return;
                                  }
                                  if (start.compareTo(data.first.time) <= 0) {
                                    return;
                                  }
                                  model.changeScope(start, end);
                                },
                                child: Sparkline(
                                  dateFormat: model.dateFormat,
                                  data: data,
                                  suppleData: model.suppleData,
                                  startTime: model.startTime,
                                  endTime: model.endTime,
                                  lineColor: Palette.darkSkyBlue,
                                  timeLineGap: Duration(
                                      seconds: 5 *
                                          marketDurationSecondMap[
                                              model.marketDuration]),
                                  lineWidth: 1,
                                  gridLineWidth: 0.5,
                                  width: widget.width,
                                  fillGradient: LinearGradient(
                                      colors: [
                                        Palette.lineGradintColorStart,
                                        Palette.lineGradientColorEnd
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter),
                                  gridLineColor: Palette.veryLightPinkTwo,
                                  pointSize: 8.0,
                                  pointColor: Palette.darkSkyBlue,
                                  repaint: model,
                                ),
                              )
                            : kline == null || kline.isEmpty
                                ? SpinKitWave(
                                    color: Palette.redOrange,
                                    size: 20,
                                  )
                                : KChartWidget(
                                    kline,
                                    isLine: false,
                                    mainState: MainState.MA,
                                    secondaryState: SecondaryState.NONE,
                                    volState: VolState.NONE,
                                    fractionDigits: 4,
                                  )),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

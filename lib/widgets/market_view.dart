import 'package:bbb_flutter/helper/common_utils.dart';
import 'package:bbb_flutter/helper/time_duration_calculate_helper.dart';
import 'package:bbb_flutter/logic/market_vm.dart';
import 'package:bbb_flutter/logic/order_vm.dart';
import 'package:bbb_flutter/logic/trade_vm.dart';
import 'package:bbb_flutter/manager/market_manager.dart';
import 'package:bbb_flutter/models/response/websocket_percentage_response.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/sparkline.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
    initModel = MarketViewModel(mtm: widget.mtm);
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

    if (widget.isTrade) {
      trade = Provider.of<TradeViewModel>(context);
    } else {
      order = Provider.of<OrderViewModel>(context);
    }

    return Consumer3<List<TickerData>, TickerData, WebSocketPercentageResponse>(
      builder: (context, data, last, percentage, child) {
        if (data == null || percentage == null) {
          return SpinKitWave(
            color: Palette.redOrange,
            size: 20,
          );
        }
        var klines = data;
        if (!isAllEmpty(data) && (data.last.time.minute == last.time.minute)) {
          klines.removeLast();
          klines.add(last);
        } else {
          if (last != null) {
            klines.add(last);
          }
        }
        // locator.get<Logger>().finest(last.value);

        return BaseWidget<MarketViewModel>(
          model: initModel,
          onModelReady: (model) {
            model.changeDuration(MarketDuration.oneMin);
            model.seedToCurrent();
          },
          builder: (context, model, child) {
            if (order != null) {
              final orderModel = order.getCurrentOrder();
              if (orderModel != null) {
                final contract = locator
                    .get<RefManager>()
                    .getContractFromId(orderModel.contractId);

                model.supplyDataWithTrade(data, order, contract);
              } else {
                model.supplyDataWithTrade(data, order, null);
              }
            }

            if (trade != null) {
              model.supplyDataWithOrder(
                  data, trade.orderForm, trade.contract.strikeLevel);
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
                            length: 4,
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
                                    model.changeDuration(MarketDuration.oneMin);
                                    break;
                                  case 1:
                                    model
                                        .changeDuration(MarketDuration.fiveMin);
                                    break;
                                  case 2:
                                    model
                                        .changeDuration(MarketDuration.oneHour);
                                    break;
                                  case 3:
                                    model.changeDuration(MarketDuration.oneDay);
                                    break;
                                  default:
                                    model.changeDuration(MarketDuration.oneMin);
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
                        child: GestureDetector(
                          onPanStart: (details) {
                            model.lastOffset = details.globalPosition;
                          },
                          onPanUpdate: (details) {
                            double gap =
                                details.globalPosition.dx - model.lastOffset.dx;

                            double timeOffset = 30 *
                                marketDurationSecondMap[model.marketDuration] *
                                gap /
                                ScreenUtil.screenWidthDp;
                            model.lastOffset = details.globalPosition;

                            var start = model.startTime.subtract(
                                Duration(seconds: timeOffset.toInt()));
                            var end = model.endTime.subtract(
                                Duration(seconds: timeOffset.toInt()));
                            if (end.compareTo(getCorrectTime().add(Duration(
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
                            percentage: percentage,
                            dateFormat: model.dateFormat,
                            data: klines,
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

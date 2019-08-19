import 'package:bbb_flutter/helper/common_utils.dart';
import 'package:bbb_flutter/logic/market_vm.dart';
import 'package:bbb_flutter/logic/order_vm.dart';
import 'package:bbb_flutter/logic/trade_vm.dart';
import 'package:bbb_flutter/manager/market_manager.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/sparkline.dart';
import 'package:bbb_flutter/widgets/sfchart.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';


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

            double tabHeight = 20;

            return Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: order != null
                      ? DefaultTabController(
                          length: 4,
                          child: TabBar(
                            isScrollable: true,
                            labelStyle: StyleFactory.buySellExplainText,
                            indicatorWeight: 0.5,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorColor: Colors.redAccent,//Palette.subTitleColor,
                            unselectedLabelColor: Palette.descColor,
                            labelColor: Palette.subTitleColor,
                            tabs: [
                              Container(
                                height: tabHeight,
                                child: new Tab(
                                  text: I18n.of(context).oneMin,
                                ),
                              ),
                              Container(
                                height: tabHeight,
                                child: new Tab(
                                  text: I18n.of(context).fiveMin,
                                ),
                              ),
                              Container(
                                height: tabHeight,
                                child: new Tab(
                                  text: I18n.of(context).oneHour,
                                ),
                              ),
                              Container(
                                height: tabHeight,
                                child: new Tab(
                                  text: I18n.of(context).oneDay,
                                ),
                              ),
                            ],
                            onTap: (index) {
                              switch (index) {
                                case 0:
                                  model.changeDuration(MarketDuration.oneMin);
                                  break;
                                case 1:
                                  model.changeDuration(MarketDuration.fiveMin);
                                  break;
                                case 2:
                                  model.changeDuration(MarketDuration.oneHour);
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
                  child: Container(
                      height: double.infinity,
                      margin: EdgeInsets.all(0),
                      child: PriceChart(
                        data: klines,
                        zoom: true,
                        cutOff: model.suppleData==null?null:model.suppleData.cutOff,
                        takeProfit: model.suppleData==null?null:model.suppleData.takeProfit,
                      )
                  )
//                  Container(
//                      height: double.infinity,
//                      margin: EdgeInsets.only(top: 1, left: 0, right: 0),
//                      child: GestureDetector(
//                        onPanStart: (details) {
//                          model.lastOffset = details.globalPosition;
//                        },
//                        onPanUpdate: (details) {
//                          double gap =
//                              details.globalPosition.dx - model.lastOffset.dx;
//
//                          double timeOffset = 30 *
//                              marketDurationSecondMap[model.marketDuration] *
//                              gap /
//                              ScreenUtil.screenWidthDp;
//                          model.lastOffset = details.globalPosition;
//
//                          var start = model.startTime
//                              .subtract(Duration(seconds: timeOffset.toInt()));
//                          var end = model.endTime
//                              .subtract(Duration(seconds: timeOffset.toInt()));
//                          if (end.compareTo(DateTime.now().add(Duration(
//                                  seconds: 15 *
//                                      marketDurationSecondMap[
//                                          model.marketDuration]))) >
//                              0) {
//                            return;
//                          }
//                          if (start.compareTo(data.first.time) <= 0) {
//                            return;
//                          }
//                          model.changeScope(start, end);
//                        },
//                        child: Sparkline(
//                          dateFormat: model.dateFormat,
//                          data: klines,
//                          suppleData: model.suppleData,
//                          startTime: model.startTime,
//                          endTime: model.endTime,
//                          lineColor: Palette.darkSkyBlue,
//                          timeLineGap: Duration(
//                              seconds: 5 *
//                                  marketDurationSecondMap[
//                                      model.marketDuration]),
//                          lineWidth: 1,
//                          gridLineWidth: 0.5,
//                          width: widget.width,
//                          fillGradient: LinearGradient(
//                              colors: [
//                                Palette.lineGradintColorStart,
//                                Palette.lineGradientColorEnd
//                              ],
//                              begin: Alignment.topCenter,
//                              end: Alignment.bottomCenter),
//                          gridLineColor: Palette.veryLightPinkTwo,
//                          pointSize: 8.0,
//                          pointColor: Palette.darkSkyBlue,
//                          repaint: model,
//                        ),
//                      )),
                )
              ],
            );
          },
        );
      },
    );
  }
}

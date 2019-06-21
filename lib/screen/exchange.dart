import 'dart:convert';

import 'package:bbb_flutter/manager/market_manager.dart';
import 'package:bbb_flutter/models/form/order_form_model.dart';
import 'package:bbb_flutter/models/request/web_socket_request_entity.dart';
import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';

import 'package:bbb_flutter/page/drawer.dart';
import 'package:bbb_flutter/routes/routes.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/market_view.dart';
import 'package:bbb_flutter/widgets/order_info.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/logic/order_vm.dart';
import 'package:bbb_flutter/logic/trade_vm.dart';

class ExchangePage extends StatefulWidget {
  ExchangePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => _ExchangeState();
}

class _ExchangeState extends State<ExchangePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _current = 0;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await locator<RefManager>().firstLoadData();

      await locator<MarketManager>().loadMarketHistory(
          startTime: DateTime.now()
              .subtract(Duration(days: 1))
              .toUtc()
              .toIso8601String(),
          endTime: DateTime.now().toUtc().toIso8601String(),
          asset: "BXBT");
      locator<MarketManager>().initCommunication();
      locator<MarketManager>().send(jsonEncode(WebSocketRequestEntity(
              type: "subscribe", topic: "FAIRPRICE.BXBT"))
          .toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 375, height: 667)..init(context);
    var uManager = locator<UserManager>();
    var refManager = locator<RefManager>();
    return Scaffold(
        key: _scaffoldKey,
        drawer: UserDrawer(),
        appBar: AppBar(
          actions: <Widget>[
            GestureDetector(
              child: Padding(
                padding: EdgeInsets.only(right: 20),
                child: Center(
                  child: Text(
                    I18n.of(context).topUp,
                    style: StyleFactory.navButtonTitleStyle,
                    textScaleFactor: 1,
                  ),
                ),
              ),
              onTap: () {
                Navigator.of(context).pushNamed(RoutePaths.Deposit);
              },
            )
          ],
          leading: !uManager.user.logined
              ? GestureDetector(
                  child: ImageFactory.personal,
                  onTap: () {
                    if (uManager.user.logined) {
                      _scaffoldKey.currentState.openDrawer();
                    } else {
                      Navigator.of(context).pushNamed(RoutePaths.Login);
                    }
                  },
                )
              : ImageFactory.upIcon14,
          centerTitle: true,
          title: Text(".BXBT", style: StyleFactory.title),
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          elevation: 0,
        ),
        body: SafeArea(
            child: BaseWidget<OrderViewModel>(
          model: locator<OrderViewModel>(),
          onModelReady: (model) {
            if (EmptyString.contains(locator<UserManager>().user.name)) {
              model.getOrders(name: "abigale1989");
            } else {
              model.getOrders(name: locator<UserManager>().user.name);
            }
          },
          builder: (context, model, child) {
            return Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                MarketView(),
                Container(
                  margin:
                      EdgeInsets.only(bottom: 20, top: 20, left: 20, right: 20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: WidgetFactory.button(
                              data: I18n.of(context).buyUp,
                              color: Palette.redOrange,
                              onPressed: () {
                                locator<TradeViewModel>().orderForm = OrderForm(
                                    cutoff: 50,
                                    takeProfit: 50,
                                    investAmount: 0,
                                    totalAmount:
                                        Asset(amount: 0, symbol: "USDT"),
                                    fee: Asset(amount: 0, symbol: "USDT"));
                                Navigator.pushNamed(context, RoutePaths.Trade,
                                    arguments: RouteParamsOfTrade(
                                        contract: Contract(),
                                        isUp: true,
                                        title: "ttes"));
                              })),
                      Container(
                        width: 20,
                      ),
                      Expanded(
                          flex: 1,
                          child: WidgetFactory.button(
                              data: I18n.of(context).buyDown,
                              color: Palette.shamrockGreen,
                              onPressed: () {
                                locator<TradeViewModel>().orderForm = OrderForm(
                                    cutoff: 50,
                                    takeProfit: 50,
                                    investAmount: 0,
                                    totalAmount:
                                        Asset(amount: 0, symbol: "USDT"),
                                    fee: Asset(amount: 0, symbol: "USDT"));
                                Navigator.pushNamed(context, RoutePaths.Trade,
                                    arguments: RouteParamsOfTrade(
                                        contract: Contract(),
                                        isUp: false,
                                        title: "ttes"));
                              })),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  margin: Dimen.pageMargin,
                  child: Align(
                    child: Text(
                      I18n.of(context).myOrdersStock,
                      style: StyleFactory.title,
                    ),
                    alignment: Alignment.bottomLeft,
                  ),
                ),
                (model.orders == null || model.orders.isEmpty)
                    ? _emptyStockWidget()
                    : _stockWidget()
              ],
            ));
          },
        )));
  }

  Widget _emptyStockWidget() {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ImageFactory.emptyStock,
            Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(I18n.of(context).orderEmpty,
                    style: StyleFactory.hintStyle))
          ],
        ),
      ),
    );
  }

  Widget _stockWidget() {
    return Stack(children: [
      MyOrderView(),
      // Positioned(
      //     top: 200.0,
      //     left: 0.0,
      //     right: 0.0,
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: Provider.of<OrderViewModel>(context)
      //           .orders
      //           .asMap()
      //           .map((i, element) {
      //             return MapEntry(
      //                 i,
      //                 Container(
      //                   width: 8.0,
      //                   height: 8.0,
      //                   margin: EdgeInsets.fromLTRB(2, 6, 2, 15),
      //                   decoration: BoxDecoration(
      //                       shape: BoxShape.circle,
      //                       color: _current == i
      //                           ? Palette.redOrange
      //                           : Palette.hintTitleColor),
      //                 ));
      //           })
      //           .values
      //           .toList(),
      //     ))
    ]);
  }
}

class MyOrderView extends StatelessWidget {
  const MyOrderView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider(
          builder: (context) => locator<MarketManager>().prices,
        ),
      ],
      child: CarouselSlider(
          height: 226,
          viewportFraction: 0.93,
          autoPlay: false,
          reverse: false,
          enableInfiniteScroll: false,
          enlargeCenterPage: true,
          onPageChanged: (index) {
            Provider.of<OrderViewModel>(context).index = index;
          },
          items: Provider.of<OrderViewModel>(context).orders.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                    decoration: DecorationFactory.cornerShadowDecoration,
                    margin: EdgeInsets.only(bottom: 30, left: 5, right: 5),
                    padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                    width: ScreenUtil.screenWidth,
                    child: OrderInfo(model: i));
              },
            );
          }).toList()),
    );
  }
}

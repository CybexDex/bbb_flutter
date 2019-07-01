import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/form/order_form_model.dart';
import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';

import 'package:bbb_flutter/routes/routes.dart';
import 'package:bbb_flutter/screen/exchange/drawer.dart';
import 'package:bbb_flutter/screen/exchange/exchange_appbar.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/market_view.dart';
import 'package:bbb_flutter/widgets/order_info.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:bbb_flutter/logic/order_vm.dart';
import 'package:bbb_flutter/logic/trade_vm.dart';

class ExchangePage extends StatelessWidget {
  ExchangePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        builder: (_) => locator.get<OrderViewModel>(),
        child: Scaffold(
            drawer: UserDrawer(),
            appBar: exchangeAppBar(),
            body: SafeArea(
                child: Container(
                    child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                    child: Container(
                  padding: Dimen.pageMargin,
                  child: MarketView(
                    isTrade: false,
                    width: ScreenUtil.screenWidthDp - 40,
                  ),
                )),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: WidgetFactory.button(
                              data: I18n.of(context).buyUp,
                              color: Palette.redOrange,
                              onPressed: () {
                                locator<TradeViewModel>().orderForm = OrderForm(
                                    isUp: true,
                                    cutoff: 50,
                                    takeProfit: 50,
                                    investAmount: 0,
                                    totalAmount:
                                        Asset(amount: 0, symbol: "USDT"),
                                    fee: Asset(amount: 0, symbol: "USDT"));
                                Navigator.pushNamed(context, RoutePaths.Trade,
                                    arguments: RouteParamsOfTrade(
                                        contract: locator
                                            .get<RefManager>()
                                            .currentContract,
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
                                    isUp: false,
                                    cutoff: 50,
                                    takeProfit: 50,
                                    investAmount: 0,
                                    totalAmount:
                                        Asset(amount: 0, symbol: "USDT"),
                                    fee: Asset(amount: 0, symbol: "USDT"));
                                Navigator.pushNamed(context, RoutePaths.Trade,
                                    arguments: RouteParamsOfTrade(
                                        contract: locator
                                            .get<RefManager>()
                                            .currentContract,
                                        isUp: false,
                                        title: "ttes"));
                              })),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 10, left: 20),
                  child: Align(
                    child: Text(
                      I18n.of(context).myOrdersStock,
                      style: StyleFactory.title,
                    ),
                    alignment: Alignment.bottomLeft,
                  ),
                ),
                Consumer2<UserManager, OrderViewModel>(
                  builder: (context, userMg, data, child) {
                    if (!userMg.user.logined || data.orders.isEmpty) {
                      return child;
                    }
                    return _stockWidget(context, data);
                  },
                  child: _emptyStockWidget(),
                ),
              ],
            )))));
  }

  Widget _emptyStockWidget() {
    return Builder(
        builder: (context) => Container(
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
            ));
  }

  Widget _stockWidget(BuildContext context, OrderViewModel bloc) {
    return Column(children: [
      CarouselSlider(
          viewportFraction: 0.92,
          aspectRatio: 335 / 194,
          autoPlay: false,
          reverse: false,
          enableInfiniteScroll: false,
          enlargeCenterPage: true,
          onPageChanged: (index) {
            bloc.index = index;
            bloc.setBusy(false);
          },
          items: bloc.orders.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                    decoration: DecorationFactory.cornerShadowDecoration,
                    margin: EdgeInsets.only(bottom: 15, left: 5, right: 5),
                    padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                    width: ScreenUtil.screenWidth,
                    child: OrderInfo(model: i));
              },
            );
          }).toList()),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: bloc.orders
            .asMap()
            .map((i, element) {
              return MapEntry(
                  i,
                  Container(
                    width: 8.0,
                    height: 8.0,
                    margin: EdgeInsets.fromLTRB(2, 0, 2, 0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: bloc.index == i
                            ? Palette.redOrange
                            : Palette.hintTitleColor),
                  ));
            })
            .values
            .toList(),
      )
    ]);
  }
}

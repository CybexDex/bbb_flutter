import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
import 'package:bbb_flutter/models/response/websocket_pnl_response.dart';

import 'package:bbb_flutter/routes/routes.dart';
import 'package:bbb_flutter/screen/exchange/drawer.dart';
import 'package:bbb_flutter/screen/exchange/exchange_appbar.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/market_view.dart';
import 'package:bbb_flutter/widgets/order_info.dart';
import 'package:bbb_flutter/widgets/sparkline.dart';
import 'package:bbb_flutter/widgets/stagger_animation.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:bbb_flutter/logic/order_vm.dart';
import 'package:bbb_flutter/manager/market_manager.dart';

class ExchangePage extends StatefulWidget {
  ExchangePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ExchangePageState createState() => _ExchangePageState();
}

class _ExchangePageState extends State<ExchangePage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: Duration(seconds: 5), vsync: this);
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        locator<MarketManager>().pnlTicker.value = null;
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        builder: (_) => locator.get<OrderViewModel>(),
        child: Consumer<UserManager>(builder: (context, user, child) {
          return Scaffold(
              resizeToAvoidBottomPadding: false,
              key: globalKey,
              drawer: user.user.logined ? UserDrawer() : null,
              appBar: exchangeAppBar(),
              body: SafeArea(
                  left: false,
                  right: false,
                  child: Container(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                          child: Container(
                        padding: Dimen.pageMargin,
                        child: Stack(
                          children: <Widget>[
                            MarketView(
                              isTrade: false,
                              width: ScreenUtil.screenWidthDp - 40,
                              mtm: locator.get(),
                            ),
                            Positioned(
                              bottom: 25,
                              child: Consumer<WebSocketPNLResponse>(
                                builder: (context, response, child) {
                                  if (response != null &&
                                      response.pnl > 0 &&
                                      !_animationController.isAnimating) {
                                    _animationController.reset();
                                    _animationController.forward();
                                    return StaggerAnimation(
                                      controller: _animationController,
                                      accountName: response.accountName,
                                      pnl: response.pnl,
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      )),
                      Container(
                        margin: EdgeInsets.all(20),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                flex: 1,
                                child: Builder(
                                  builder: (context) => WidgetFactory.button(
                                      data: I18n.of(context).buyUp,
                                      color: Palette.redOrange,
                                      onPressed: () {
                                        if (locator
                                            .get<RefManager>()
                                            .upContract
                                            .isEmpty) {
                                          showToast(context, true,
                                              I18n.of(context).toastNoContract);
                                          return;
                                        }
                                        if (locator
                                            .get<UserManager>()
                                            .user
                                            .logined) {
                                          Navigator.pushNamed(
                                                  context, RoutePaths.Trade,
                                                  arguments: RouteParamsOfTrade(
                                                      contract: locator
                                                          .get<RefManager>()
                                                          .currentUpContract,
                                                      isUp: true,
                                                      title: "ttes"))
                                              .then((v) {
                                            Provider.of<OrderViewModel>(context)
                                                .getOrders();
                                          });
                                        } else {
                                          Navigator.of(context)
                                              .pushNamed(RoutePaths.Login);
                                        }
                                      }),
                                )),
                            Container(
                              width: 20,
                            ),
                            Expanded(
                                flex: 1,
                                child: Builder(
                                  builder: (context) => WidgetFactory.button(
                                      data: I18n.of(context).buyDown,
                                      color: Palette.shamrockGreen,
                                      onPressed: () {
                                        if (locator
                                            .get<RefManager>()
                                            .downContract
                                            .isEmpty) {
                                          showToast(context, true,
                                              I18n.of(context).toastNoContract);
                                          return;
                                        }
                                        if (locator
                                            .get<UserManager>()
                                            .user
                                            .logined) {
                                          Navigator.pushNamed(
                                                  context, RoutePaths.Trade,
                                                  arguments: RouteParamsOfTrade(
                                                      contract: locator
                                                          .get<RefManager>()
                                                          .currentDownContract,
                                                      isUp: false,
                                                      title: "ttes"))
                                              .then((v) {
                                            Provider.of<OrderViewModel>(context)
                                                .getOrders();
                                          });
                                        } else {
                                          Navigator.of(context)
                                              .pushNamed(RoutePaths.Login);
                                        }
                                      }),
                                )),
                          ],
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.only(bottom: 10, left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              I18n.of(context).myOrdersStock,
                              style: StyleFactory.title,
                            ),
                            Consumer<OrderViewModel>(
                              builder: (context, model, child) {
                                return Text(
                                  "${I18n.of(context).totalPnl} ${model.totlaPnl.toStringAsFixed(4)}",
                                );
                              },
                            )
                          ],
                        ),
                      ),
                      Consumer4<UserManager, OrderViewModel,
                          RefContractResponseModel, TickerData>(
                        builder: (context, userMg, data, ref, __, child) {
                          if (!userMg.user.logined ||
                              data.orders.isEmpty ||
                              locator.get<MarketManager>().lastTicker.value ==
                                  null) {
                            return child;
                          }
                          return _stockWidget(context, data);
                        },
                        child: _emptyStockWidget(),
                      ),
                    ],
                  ))));
        }));
  }

  Widget _emptyStockWidget() {
    return Builder(
        builder: (context) => Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(R.resAssetsIconsIcEmpty),
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
      ),
      SizedBox(
        height: 10,
      )
    ]);
  }
}

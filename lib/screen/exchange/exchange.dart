import 'dart:io';

import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/manager/ref_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/bbb_query_response/contract_response.dart';
import 'package:bbb_flutter/models/response/update_response.dart';
import 'package:bbb_flutter/models/response/websocket_percentage_response.dart';
import 'package:bbb_flutter/models/response/websocket_pnl_response.dart';

import 'package:bbb_flutter/routes/routes.dart';
import 'package:bbb_flutter/screen/exchange/exchange_appbar.dart';
import 'package:bbb_flutter/screen/exchange/exchange_header.dart';
import 'package:bbb_flutter/services/network/configure/configure_api.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/market_view.dart';
import 'package:bbb_flutter/widgets/order_info.dart';
import 'package:bbb_flutter/widgets/percentage_bar_painter.dart';
import 'package:bbb_flutter/widgets/sparkline.dart';
import 'package:bbb_flutter/widgets/stagger_animation.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:bbb_flutter/logic/order_vm.dart';
import 'package:bbb_flutter/manager/market_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info/package_info.dart';

class ExchangePage extends StatefulWidget {
  ExchangePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ExchangePageState createState() => _ExchangePageState();
}

class _ExchangePageState extends State<ExchangePage>
    with SingleTickerProviderStateMixin<ExchangePage> {
  AnimationController _animationController;
  bool isExpandOpen = false;

  @override
  void initState() {
    super.initState();
    checkConfiguretion();
    _animationController = AnimationController(duration: Duration(seconds: 5), vsync: this);
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
        create: (_) => locator.get<OrderViewModel>(),
        child: Consumer<UserManager>(builder: (context, user, child) {
          return Scaffold(
              key: globalKey,
              resizeToAvoidBottomPadding: false,
              appBar: exchangeAppBar(context: globalKey.currentContext),
              body: SafeArea(
                  left: false,
                  right: false,
                  child: Container(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      ExchangeHeader(),
                      Expanded(
                          flex: 10,
                          child: Container(
                            child: Stack(
                              children: <Widget>[
                                MarketView(
                                  isTrade: false,
                                  width: ScreenUtil.screenWidthDp - 40,
                                  mtm: locator.get(),
                                ),
                                Positioned(
                                  bottom: 25,
                                  left: 15,
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
                                          isUp: response.contract.contains("N"),
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
                      Consumer<WebSocketPercentageResponse>(
                        builder: (context, percentage, child) {
                          return percentage == null ||
                                  (percentage.nPercentage == 0 && percentage.xPercentage == 0)
                              ? Container()
                              : Visibility(
                                  visible: !isExpandOpen,
                                  child: Container(
                                    height: 20,
                                    padding: Dimen.pageMargin,
                                    color: Colors.white,
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        return Container(
                                          child: CustomPaint(
                                            size: Size.infinite,
                                            painter: PercentageBarPainter(
                                                context: context,
                                                percentage: percentage.nPercentage),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                        },
                      ),
                      Visibility(
                        visible: !isExpandOpen,
                        child: Container(
                          padding: EdgeInsets.only(
                              right: ScreenUtil.getInstance().setWidth(20),
                              left: ScreenUtil.getInstance().setWidth(20),
                              bottom: ScreenUtil.getInstance().setHeight(15),
                              top: ScreenUtil.getInstance().setHeight(15)),
                          color: Colors.white,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  flex: 1,
                                  child: Builder(
                                    builder: (context) => WidgetFactory.button(
                                        data: I18n.of(context).buyUp,
                                        color: Palette.redOrange,
                                        topPadding: ScreenUtil.getInstance().setHeight(10),
                                        bottomPadding: ScreenUtil.getInstance().setHeight(10),
                                        onPressed: () {
                                          _onClickBuyOrSellButton(
                                              ref: locator.get(),
                                              user: locator.get(),
                                              isUp: true,
                                              orderViewModel: Provider.of(context));
                                        }),
                                  )),
                              Container(
                                width: ScreenUtil.getInstance().setWidth(20),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Builder(
                                    builder: (context) => WidgetFactory.button(
                                        data: I18n.of(context).buyDown,
                                        color: Palette.shamrockGreen,
                                        topPadding: ScreenUtil.getInstance().setHeight(10),
                                        bottomPadding: ScreenUtil.getInstance().setHeight(10),
                                        onPressed: () {
                                          _onClickBuyOrSellButton(
                                              ref: locator.get(),
                                              user: locator.get(),
                                              isUp: false,
                                              orderViewModel: Provider.of(context));
                                        }),
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        margin: EdgeInsets.only(top: 10),
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Stack(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isExpandOpen = !isExpandOpen;
                                });
                              },
                              child: Center(
                                child: isExpandOpen
                                    ? SvgPicture.asset(
                                        R.resAssetsIconsIcPullDown,
                                        width: 100,
                                      )
                                    : SvgPicture.asset(
                                        R.resAssetsIconsIcPullUp,
                                        width: 100,
                                      ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 8, bottom: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("总盈亏(USDT)：", style: StyleNewFactory.grey14),
                                  Consumer<OrderViewModel>(
                                    builder: (context, model, child) {
                                      return Text(
                                        "${model.totlaPnl.toStringAsFixed(4)}",
                                        style: model.totlaPnl >= 0
                                            ? StyleFactory.buyUpOrderInfo
                                            : StyleFactory.buyDownOrderInfo,
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      new Baseline(
                        baseline: 1,
                        baselineType: TextBaseline.alphabetic,
                        child: new Container(
                          color: Color(0xFFededed),
                          height: 1,
                          width: double.infinity,
                        ),
                      ),
                      Visibility(
                        visible: isExpandOpen,
                        child: Consumer4<UserManager, OrderViewModel, ContractResponse, TickerData>(
                          builder: (context, userMg, data, ref, __, child) {
                            if (!userMg.user.logined ||
                                data.orders.isEmpty ||
                                locator.get<MarketManager>().lastTicker.value == null ||
                                locator.get<RefManager>().refDataControllerNew.value == null) {
                              return child;
                            }
                            return _stockWidget(context, data);
                          },
                          child: Container(child: _emptyStockWidget()),
                        ),
                      ),
                    ],
                  ))));
        }));
  }

  checkConfiguretion() async {
    await locator.get<ConfigureApi>().getUpdateInfo(isIOS: Platform.isIOS);

    UpdateResponse updateResponse = locator.get<ConfigureApi>().updateResponse;
    bool isForce = updateResponse.isForceUpdate(locator.get<PackageInfo>().version);
    if (updateResponse.needUpdate(locator.get<PackageInfo>().version)) {
      Future.delayed(Duration.zero, () {
        showDialog(
            barrierDismissible: !isForce,
            context: context,
            builder: (context) {
              return DialogFactory.normalConfirmDialog(context,
                  title: I18n.of(context).updateTitle,
                  isForce: isForce,
                  content: updateResponse.cnUpdateInfo, onConfirmPressed: () {
                launchURL(url: updateResponse.url);
                if (!isForce) {
                  Navigator.of(context, rootNavigator: true).pop();
                  checkAdd(context, activityTypes[ActivityType.mainActivity]);
                }
              });
            });
      });
    } else {
      checkAdd(context, activityTypes[ActivityType.mainActivity]);
    }
  }

  Widget _emptyStockWidget() {
    return Builder(
        builder: (context) => Container(
              height: ScreenUtil.getInstance().setHeight(200),
              child: Align(
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    R.resAssetsIconsIcNoStoke,
                    width: 113,
                    height: 118,
                  )),
            ));
  }

  _onClickBuyOrSellButton(
      {RefManager ref, UserManager user, bool isUp, OrderViewModel orderViewModel}) async {
    if (isUp
        ? (ref.upContract == null || ref.upContract.isEmpty)
        : (ref.downContract == null || ref.downContract.isEmpty)) {
      showNotification(context, true, I18n.of(context).toastNoContract);
      return;
    }
    if (user.user.logined) {
      TextEditingController controller = TextEditingController();
      showUnlockAndBiometricDialog(
          context: context,
          passwordEditor: controller,
          callback: () {
            if (ref.currentUpContract == null ||
                ref.currentDownContract == null ||
                !ref.isIdSelectedByUser) {
              ref.updateUpContractId();
              ref.updateDownContractId();
            }
            Navigator.pushNamed(context, RoutePaths.Trade,
                    arguments: RouteParamsOfTrade(isUp: isUp, isCoupon: false))
                .then((v) {
              orderViewModel.getOrders();
            });
          });
      // if (user.user.isLocked) {
      // showDialog(
      //     context: context,
      //     builder: (context) {
      //       return DialogFactory.unlockDialog(context, controller: controller);
      //     }).then((value) {
      //   if (value != null && value) {
      //     if (ref.currentUpContract == null ||
      //         ref.currentDownContract == null ||
      //         !ref.isIdSelectedByUser) {
      //       ref.updateUpContractId();
      //       ref.updateDownContractId();
      //     }
      //     Navigator.pushNamed(context, RoutePaths.Trade,
      //             arguments: RouteParamsOfTrade(isUp: isUp, isCoupon: false))
      //         .then((v) {
      //       orderViewModel.getOrders();
      //     });
      //   }
      // });
      // if (await auth.canCheckBiometrics) {
      //   if (await auth.authenticateWithBiometrics(localizedReason: "test", stickyAuth: true)) {

      //   }
      // } else {
      //   showThemeToast("not support");
      // }
      // } else {

      // }
      // if (ref.currentUpContract == null ||
      //     ref.currentDownContract == null ||
      //     !ref.isIdSelectedByUser) {
      //   ref.updateUpContractId();
      //   ref.updateDownContractId();
      // }
      // Navigator.pushNamed(context, RoutePaths.Trade,
      //         arguments: RouteParamsOfTrade(isUp: isUp, isCoupon: false))
      //     .then((v) {
      //   orderViewModel.getOrders();
      // });
    } else {
      Navigator.of(context).pushNamed(RoutePaths.Login);
    }
  }

  // Widget _newStockWidget(BuildContext context, OrderViewModel orderViewModel) {
  //   return Container(
  //     color: Colors.white,
  //     child: Column(
  //       children: <Widget>[
  //         Container(
  //           padding: EdgeInsets.only(right: 15, left: 15, top: 8, bottom: 8),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.end,
  //             children: <Widget>[
  //               // GestureDetector(
  //               //   onTap: () {
  //               //     Navigator.pushNamed(context, RoutePaths.AllLimitOrders);
  //               //   },
  //               //   child: Row(
  //               //     children: <Widget>[
  //               //       Text(I18n.of(context).holdAll,
  //               //           style: StyleNewFactory.black15),
  //               //       SizedBox(
  //               //         width: 10,
  //               //       ),
  //               //       SvgPicture.asset(
  //               //         R.resAssetsIconsHoldAll,
  //               //         width: 14,
  //               //         height: 15,
  //               //       )
  //               //     ],
  //               //   ),
  //               // ),
  //               GestureDetector(
  //                 onTap: () {
  //                   openDialog(context, orderViewModel.orders[0]);
  //                 },
  //                 child: Row(
  //                   children: <Widget>[
  //                     Container(
  //                       padding: EdgeInsets.only(right: 9),
  //                       child: Text(I18n.of(context).resetPnl,
  //                           style: StyleNewFactory.black15),
  //                     ),
  //                     SvgPicture.asset(
  //                       R.resAssetsIconsIcReviseYellow,
  //                       width: 14,
  //                       height: 14,
  //                     ),
  //                   ],
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //         Container(
  //             height: ScreenUtil.getInstance().setHeight(190),
  //             width: ScreenUtil.screenWidth,
  //             color: Colors.white,
  //             child: OrderInfo(
  //               model: orderViewModel.orders[0],
  //               isAll: false,
  //             )),
  //       ],
  //     ),
  //   );
  // }

  Widget _stockWidget(BuildContext context, OrderViewModel bloc) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Column(children: [
        CarouselSlider(
            viewportFraction: 0.92,
            aspectRatio: 350 / 200,
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
                      padding: EdgeInsets.fromLTRB(5, 16, 5, 0),
                      width: ScreenUtil.screenWidth,
                      child: OrderInfo(
                        model: i,
                        isAll: false,
                      ));
                },
              );
            }).toList()),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: bloc.orders
        //       .asMap()
        //       .map((i, element) {
        //         return MapEntry(
        //             i,
        //             Container(
        //               width: 8.0,
        //               height: 8.0,
        //               margin: EdgeInsets.fromLTRB(2, 0, 2, 0),
        //               decoration: BoxDecoration(
        //                   shape: BoxShape.circle,
        //                   color: bloc.index == i
        //                       ? Palette.redOrange
        //                       : Palette.hintTitleColor),
        //             ));
        //       })
        //       .values
        //       .toList(),
        // ),
        // SizedBox(
        //   height: 10,
        // )
      ]),
    );
  }
}

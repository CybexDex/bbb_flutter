import 'dart:convert';

import 'package:bbb_flutter/blocs/bloc_refData.dart';
import 'package:bbb_flutter/blocs/get_order_bloc.dart';
import 'package:bbb_flutter/colors/palette.dart';
import 'package:bbb_flutter/common/decoration_factory.dart';
import 'package:bbb_flutter/common/dimen.dart';
import 'package:bbb_flutter/common/image_factory.dart';
import 'package:bbb_flutter/common/style_factory.dart';
import 'package:bbb_flutter/common/widget_factory.dart';
import 'package:bbb_flutter/env.dart';
import 'package:bbb_flutter/models/entity/user_entity.dart';
import 'package:bbb_flutter/models/request/web_socket_request_entity.dart';
import 'package:bbb_flutter/models/response/order_response_model.dart';
import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
import 'package:bbb_flutter/models/response/web_socket_n_x_price_response_entity.dart';
import 'package:bbb_flutter/routes/routes.dart';
import 'package:bbb_flutter/websocket/websocket_bloc.dart';
import 'package:bbb_flutter/widgets/injector.dart';
import 'package:bbb_flutter/widgets/order_info.dart';
import 'package:bbb_flutter/widgets/sparkline.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../env.dart';

class ExchangePage extends StatefulWidget {
  ExchangePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => _ExchangeState();
}

class _ExchangeState extends State<ExchangePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GetOrderBloc _getOrderBloc = GetOrderBloc();
  int _current = 0;
  List<TickerData> _listTickerData = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final injector = InjectorWidget.of(context);
    ScreenUtil.instance = ScreenUtil(width: 375, height: 667)..init(context);
    _getOrderBloc.getOrder(name: "abigale1989");
    injector.marketHistoryBloc.fetchPriceHistory(
        startTime: DateTime.now()
            .subtract(Duration(days: 30))
            .toUtc()
            .toIso8601String(),
        endTime: DateTime.now().toUtc().toIso8601String(),
        asset: "BXBT");

    return Scaffold(
        key: _scaffoldKey,
        drawer: _drawer(),
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
                if (injector.userBloc.userSubject.value.isLogin) {
                  injector.userBloc.logout();
                } else {
                  injector.userBloc.loginWith(name: "xx");
                }
              },
            )
          ],
          leading: StreamBuilder<UserEntity>(
            initialData: UserEntity(),
            builder: (context, snapshot) {
              if (!snapshot.data.isLogin) {
                return GestureDetector(
                  child: ImageFactory.personal,
                  onTap: () {
                    _scaffoldKey.currentState.openDrawer();
                  },
                );
              } else {
                return ImageFactory.upIcon14;
              }
            },
            stream: injector.userBloc.userSubject.stream,
          ),
          centerTitle: true,
          title: Text(".BXBT", style: StyleFactory.title),
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          elevation: 0,
        ),
        body: SafeArea(
            child: Container(
                child: StreamBuilder(
                    stream: WebSocketBloc().getChannelStream(),
                    builder: (context, wbSnapshot) {
                      if (wbSnapshot == null || !wbSnapshot.hasData) {
                        return Container();
                      }
                      var wbResponse = WebSocketNXPriceResponseEntity.fromJson(
                          json.decode(wbSnapshot.data));
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                              child: Container(
                            decoration:
                                DecorationFactory.cornerShadowDecoration,
                            height: double.infinity,
                            margin:
                                EdgeInsets.only(top: 1, left: 20, right: 20),
                            child: Container(
                                child: StreamBuilder<List<TickerData>>(
                              builder: (context, snapshot) {
                                if (snapshot == null || !snapshot.hasData) {
                                  return Container();
                                }
                                List<TickerData> response = snapshot.data;
                                _listTickerData.addAll(response);
                                return Sparkline(
                                  data: _listTickerData
                                    ..add(TickerData(wbResponse.px,
                                        DateTime.parse(wbResponse.time))),
                                  suppleData: SuppleData(
                                      stopTime: DateTime.now()
                                          .add(Duration(minutes: 2)),
                                      endTime: DateTime.now()
                                          .add(Duration(minutes: 12)),
                                      cutOff: 1.7,
                                      takeProfit: 7.8,
                                      underOrder: 4.5,
                                      current: 6.0),
                                  startTime: DateTime.now()
                                      .subtract(Duration(minutes: 15)),
                                  startLineOfTime: DateTime.now()
                                      .subtract(Duration(minutes: 15)),
                                  endTime:
                                      DateTime.now().add(Duration(minutes: 15)),
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
                                );
                              },
                              stream: injector.marketHistoryBloc
                                  .marketHistorySubject.stream,
                            )),
                          )),
                          Container(
                            margin: EdgeInsets.only(
                                bottom: 20, top: 20, left: 20, right: 20),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: WidgetFactory.button(
                                        data: I18n.of(context).buyUp,
                                        color: Palette.redOrange,
                                        onPressed: () {
                                          router.navigateTo(
                                              context, "/trade/buyUp",
                                              transition:
                                                  TransitionType.inFromRight);
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
                                          router.navigateTo(
                                              context, "/trade/buyDown",
                                              transition:
                                                  TransitionType.inFromRight);
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
                          StreamBuilder<List<OrderResponseModel>>(
                            stream: _getOrderBloc.getOrderBloc.stream,
                            builder: (context, snapShot) {
                              if (snapShot == null || !snapShot.hasData) {
                                return _emptyStockWidget();
                              } else {
                                List<OrderResponseModel> orderResponse =
                                    snapShot.data;
                                refDataBloc.getRefData();
                                return StreamBuilder<RefContractResponseModel>(
                                  stream: refDataBloc.subject.stream,
                                  builder: (context, snapShot) {
                                    log.info(snapShot.data.chainId);
                                    if (snapShot == null || !snapShot.hasData) {
                                      return _emptyStockWidget();
                                    } else {
                                      var response = snapShot.data;
                                      return _stockWidget(
                                          orderResponse: orderResponse,
                                          refContract: response,
                                          webSocketResponse: wbResponse);
                                    }
                                  },
                                );
                              }
                            },
                          )
                        ],
                      );
                    }))));
  }

  @override
  void dispose() {
    WebSocketBloc().reset();
    _getOrderBloc.dispose();
    refDataBloc.dispose();

    super.dispose();
  }

  sendMessage() {}

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

  CarouselSlider _slide(
      {List<OrderResponseModel> orderResponse,
      RefContractResponseModel refContract,
      WebSocketNXPriceResponseEntity webSocketResponse}) {
    return CarouselSlider(
        height: 226,
        viewportFraction: 0.93,
        autoPlay: false,
        reverse: false,
        enableInfiniteScroll: false,
        enlargeCenterPage: true,
        onPageChanged: (index) {
          setState(() {
            _current = index;
          });
        },
        items: orderResponse.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                  decoration: DecorationFactory.cornerShadowDecoration,
                  margin: EdgeInsets.only(bottom: 30, left: 5, right: 5),
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                  width: ScreenUtil.screenWidth,
                  child: OrderInfo(
                    orderResponseModel: i,
                    refContractResponseModel: refContract,
                    webSocketNXPriceResponseEntity: webSocketResponse,
                  ));
            },
          );
        }).toList());
  }

  Widget _stockWidget(
      {List<OrderResponseModel> orderResponse,
      RefContractResponseModel refContract,
      WebSocketNXPriceResponseEntity webSocketResponse}) {
    return Stack(children: [
      _slide(
          orderResponse: orderResponse,
          refContract: refContract,
          webSocketResponse: webSocketResponse),
      Positioned(
          top: 200.0,
          left: 0.0,
          right: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: orderResponse
                .asMap()
                .map((i, element) {
                  return MapEntry(
                      i,
                      Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.fromLTRB(2, 6, 2, 15),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _current == i
                                ? Palette.redOrange
                                : Palette.hintTitleColor),
                      ));
                })
                .values
                .toList(),
          ))
    ]);
  }

  Drawer _drawer() {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the Drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              children: <Widget>[
                Align(
                  child: GestureDetector(
                    child: ImageFactory.back,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  alignment: Alignment.topLeft,
                )
              ],
            ),
          ),
          ListTile(
            title: Text(
              I18n.of(context).topUp,
              style: StyleFactory.cellTitleStyle,
            ),
            trailing: GestureDetector(
              child: ImageFactory.rowArrow,
              onTap: () {},
            ),
            onTap: () {
              // Update the state of the app
              // ...
            },
          ),
          Container(
            height: 0.5,
            margin: EdgeInsets.only(left: 20, right: 20),
            color: Palette.separatorColor,
          ),
          ListTile(
            title: Text(
              I18n.of(context).withdraw,
              style: StyleFactory.cellTitleStyle,
            ),
            trailing: GestureDetector(
              child: ImageFactory.rowArrow,
              onTap: () {},
            ),
            onTap: () {
              // Update the state of the app
              // ...
            },
          ),
          Container(
            height: 0.5,
            margin: EdgeInsets.only(left: 20, right: 20),
            color: Palette.separatorColor,
          ),
          ListTile(
            title: Text(
              I18n.of(context).cashRecords,
              style: StyleFactory.cellTitleStyle,
            ),
            trailing: GestureDetector(
              child: ImageFactory.rowArrow,
              onTap: () {},
            ),
            onTap: () {
              // Update the state of the app
              // ...
            },
          ),
          Container(
            height: 0.5,
            margin: EdgeInsets.only(left: 20, right: 20),
            color: Palette.separatorColor,
          ),
          ListTile(
            title: Text(
              I18n.of(context).transactionRecords,
              style: StyleFactory.cellTitleStyle,
            ),
            trailing: GestureDetector(
              child: ImageFactory.rowArrow,
              onTap: () {},
            ),
            onTap: () {
              // Update the state of the app
              // ...
            },
          ),
          Container(
            height: 0.5,
            margin: EdgeInsets.only(left: 20, right: 20),
            color: Palette.separatorColor,
          ),
        ],
      ),
    );
  }
}

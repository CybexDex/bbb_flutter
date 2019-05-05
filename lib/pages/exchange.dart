import 'package:bbb_flutter/colors/palette.dart';
import 'package:bbb_flutter/common/decoration_factory.dart';
import 'package:bbb_flutter/common/dimen.dart';
import 'package:bbb_flutter/common/image_factory.dart';
import 'package:bbb_flutter/common/style_factory.dart';
import 'package:bbb_flutter/common/widget_factory.dart';
import 'package:bbb_flutter/generated/i18n.dart';
import 'package:bbb_flutter/models/entity/user_entity.dart';
import 'package:bbb_flutter/routes/routes.dart';
import 'package:bbb_flutter/widgets/injector.dart';
import 'package:bbb_flutter/widgets/order_info.dart';
import 'package:bbb_flutter/widgets/sparkline.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final injector = InjectorWidget.of(context);
    ScreenUtil.instance = ScreenUtil(width: 375, height: 667)..init(context);

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
                    I18n.of(context).top_up,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                  child: Container(
                decoration: DecorationFactory.cornerShadowDecoration,
                height: double.infinity,
                margin: EdgeInsets.only(top: 1, left: 20, right: 20),
                child: Container(
                  child: Sparkline(
                    data: [
                      TickerData(
                          3.4,
                          DateTime.now()
                              .subtract(Duration(minutes: 14, seconds: 22))),
                      TickerData(
                          5.4,
                          DateTime.now()
                              .subtract(Duration(minutes: 10, seconds: 28))),
                      TickerData(
                          8.4,
                          DateTime.now()
                              .subtract(Duration(minutes: 5, seconds: 42))),
                      TickerData(
                          1.4,
                          DateTime.now()
                              .add(Duration(minutes: 11, seconds: 12))),
                      TickerData(
                          3.5,
                          DateTime.now()
                              .add(Duration(minutes: 13, seconds: 2))),
                      TickerData(
                          1.7,
                          DateTime.now()
                              .add(Duration(minutes: 14, seconds: 2))),
                    ],
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
                    fillGradient: LinearGradient(colors: [
                      Palette.darkSkyBlue.withAlpha(100),
                      Palette.darkSkyBlue.withAlpha(0)
                    ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                    gridLineColor: Palette.veryLightPinkTwo,
                    pointSize: 8.0,
                    pointColor: Palette.darkSkyBlue,
                  ),
                ),
              )),
              Container(
                margin:
                    EdgeInsets.only(bottom: 20, top: 20, left: 20, right: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: WidgetFactory.button(
                            data: I18n.of(context).buy_up,
                            color: Palette.redOrange,
                            onPressed: () {
                              router.navigateTo(context, "/trade",
                                  transition: TransitionType.inFromRight);
                            })),
                    Container(
                      width: 20,
                    ),
                    Expanded(
                        flex: 1,
                        child: WidgetFactory.button(
                            data: I18n.of(context).buy_down,
                            color: Palette.shamrockGreen,
                            onPressed: () {
                              router.navigateTo(context, "/trade",
                                  transition: TransitionType.inFromRight);
                            })),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 10),
                margin: Dimen.pageMargin,
                child: Align(
                  child: Text(
                    I18n.of(context).my_orders_stock,
                    style: StyleFactory.title,
                  ),
                  alignment: Alignment.bottomLeft,
                ),
              ),
              _stockWidget(),
            ],
          ),
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
                child: Text(I18n.of(context).order_empty,
                    style: StyleFactory.hintStyle))
          ],
        ),
      ),
    );
  }

  CarouselSlider _slide() {
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
        items: [1, 2, 3, 4, 5].map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                  decoration: DecorationFactory.cornerShadowDecoration,
                  margin: EdgeInsets.only(bottom: 30, left: 5, right: 5),
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                  width: ScreenUtil.screenWidth,
                  child: OrderInfo());
            },
          );
        }).toList());
  }

  Widget _stockWidget() {
    return Stack(children: [
      _slide(),
      Positioned(
          top: 200.0,
          left: 0.0,
          right: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [1, 2, 3, 4, 5]
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
              I18n.of(context).top_up,
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
              I18n.of(context).cash_records,
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
              I18n.of(context).transaction_records,
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

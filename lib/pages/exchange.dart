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
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class ExchangePage extends StatefulWidget {
  ExchangePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => _ExchangeState();
}

class _ExchangeState extends State<ExchangePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final injector = InjectorWidget.of(context);

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
                    S.of(context).top_up,
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
          margin: Dimen.pageMargin,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                  child: Container(
                decoration: DecorationFactory.cornerShadowDecoration,
                height: double.infinity,
                margin: EdgeInsets.only(top: 1),
              )),
              Container(
                margin: EdgeInsets.only(bottom: 20, top: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: WidgetFactory.button(
                            data: S.of(context).buy_up,
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
                            data: S.of(context).buy_down,
                            color: Palette.shamrockGreen,
                            onPressed: () {
                              router.navigateTo(context, "/trade",
                                  transition: TransitionType.inFromRight);
                            })),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Align(
                  child: Text(
                    S.of(context).my_orders_stock,
                    style: StyleFactory.title,
                  ),
                  alignment: Alignment.bottomLeft,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 30),
                decoration: DecorationFactory.cornerShadowDecoration,
                height: 194,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: _stockWidget(),
                ),
              ),
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
                child: Text(S.of(context).order_empty,
                    style: StyleFactory.hintStyle))
          ],
        ),
      ),
    );
  }

  Widget _stockWidget() {
    return OrderInfo();
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
              S.of(context).top_up,
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
              S.of(context).withdraw,
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
              S.of(context).cash_records,
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
              S.of(context).transaction_records,
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

import 'package:bbb_flutter/colors/palette.dart';
import 'package:bbb_flutter/common/decoration_factory.dart';
import 'package:bbb_flutter/common/dimen.dart';
import 'package:bbb_flutter/common/image_factory.dart';
import 'package:bbb_flutter/common/style_factory.dart';
import 'package:bbb_flutter/common/widget_factory.dart';
import 'package:bbb_flutter/widgets/order_info.dart';
import 'package:flutter/material.dart';
import 'package:bbb_flutter/generated/i18n.dart';

class ExchangePage extends StatefulWidget {
  ExchangePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => _ExchangeState();
}

class _ExchangeState extends State<ExchangePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: ImageFactory.personal,
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
                            data: S.of(context).buy_up_price("0.21863"),
                            color: Palette.redOrange,
                            onPressed: () {})),
                    Container(
                      width: 20,
                    ),
                    Expanded(
                        flex: 1,
                        child: WidgetFactory.button(
                            data: S.of(context).buy_up_price("0.21863"),
                            color: Palette.shamrockGreen,
                            onPressed: () {})),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Align(
                  child: Text(
                    "xxx",
                    style: StyleFactory.title,
                  ),
                  alignment: Alignment.bottomLeft,
                ),
              ),
              Container(
                decoration: DecorationFactory.cornerShadowDecoration,
                height: 194,
                child: _stockWidget(),
              ),
            ],
          ),
        )));
  }

  Widget _emptyStockWidget() {
    return Container(
      margin: Dimen.pageMargin,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ImageFactory.emptyStock,
            Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text("暂无持仓", style: StyleFactory.hintStyle))
          ],
        ),
      ),
    );
  }

  Widget _stockWidget() {
    return OrderInfo();
  }
}

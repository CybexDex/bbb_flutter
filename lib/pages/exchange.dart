import 'package:bbb_flutter/colors/palette.dart';
import 'package:bbb_flutter/components/style_factory.dart';
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
      body: Stack(
        children: <Widget>[
          WidgetFactory.pageTopContainer(),
          AppBar(
            leading: Image.asset("res/assets/icons/icPersonWhite.png"),
            centerTitle: true,
            title: Text(
              ".BXBT",
              style: StyleFactory.title
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          SafeArea(
              child: Container(
                  margin: WidgetFactory.pageMargin,
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: DecorationFactory.cornerShadowDecoration,
                        height: 270,
                        margin: EdgeInsets.only(top: 48),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 18),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: WidgetFactory.button(data: S.of(context).buy_up_price("0.21863"), color:Palette.redOrange, onPressed: (){})
                            ),
                            Container(
                              width: 20,
                            ),
                            Expanded(
                              flex: 1,
                              child: WidgetFactory.button(data: S.of(context).buy_up_price("0.21863"), color:Palette.shamrockGreen, onPressed: (){})
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: WidgetFactory.pageMargin,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset("res/assets/images/icEmpty.png"),
                                Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text("暂无持仓", style: StyleFactory.hintStyle)
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )
              ),
          )
        ],
      )
    );
  }
}

//appBar: AppBar(
//centerTitle: true,
//title: Text(".BXBT"),
//backgroundColor: Colors.transparent,
//elevation: 0,
//),
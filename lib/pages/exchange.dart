import 'package:bbb_flutter/colors/palette.dart';
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
          Container(
            height: 130,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("res/assets/images/mask.png"),
                  fit: BoxFit.fill,
                )
            )
          ),
          AppBar(
            leading: Image.asset("res/assets/icons/icPersonWhite.png"),
            centerTitle: true,
            title: Text(
              ".BXBT",
              style: const TextStyle(
                  color: Palette.buttonPrimaryColor,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  fontSize: 18.0
              )
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          SafeArea(
              child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: Palette.pagePrimaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [BoxShadow(
                                color: Color.fromRGBO(102, 102, 102, 0.1),
                                offset: Offset(0, 4),
                                spreadRadius: 2,
                                blurRadius: 8
                            )]
                        ),
                        height: 270,
                        margin: EdgeInsets.only(top: 48),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 18),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: RaisedButton(
                                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(4)),
                                onPressed: (){},
                                color: Palette.redOrange,
                                textColor: Colors.white,
                                child: Padding(padding: EdgeInsets.only(top: 14, bottom: 14),
                                    child: Text(S.of(context).buy_up_price("0.21863"), style: Theme.of(context).textTheme.button)
                                ),
                              ),
                            ),
                            Container(
                              width: 20,
                            ),
                            Expanded(
                              flex: 1,
                              child: RaisedButton(
                                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(4)),
                                onPressed: (){},
                                color: Palette.shamrockGreen,
                                textColor: Colors.white,
                                child: Padding(padding: EdgeInsets.only(top: 14, bottom: 14),
                                    child: Text(S.of(context).buy_up_price("0.21863"), style: Theme.of(context).textTheme.button)
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 20, top: 20),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset("res/assets/images/icEmpty.png"),
                                Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text("暂无持仓",
                                      style: const TextStyle(
                                          color:  const Color(0xffcccccc),
                                          fontWeight: FontWeight.w400,
                                          fontStyle:  FontStyle.normal,
                                          fontSize: 12.0
                                      )),
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
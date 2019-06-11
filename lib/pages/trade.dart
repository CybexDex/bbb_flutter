import 'package:bbb_flutter/blocs/bloc_refData.dart';
import 'package:bbb_flutter/colors/palette.dart';
import 'package:bbb_flutter/common/decoration_factory.dart';
import 'package:bbb_flutter/common/dialog_factory.dart';
import 'package:bbb_flutter/common/dimen.dart';
import 'package:bbb_flutter/common/image_factory.dart';
import 'package:bbb_flutter/common/style_factory.dart';
import 'package:bbb_flutter/common/widget_factory.dart';
import 'package:bbb_flutter/models/request/post_order_request_model.dart';
import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
import 'package:bbb_flutter/routes/routes.dart';
import 'package:bbb_flutter/env.dart';
import 'package:bbb_flutter/widgets/buy_or_sell_bottom.dart';
import 'package:bbb_flutter/widgets/order_form.dart';
import 'package:bbb_flutter/widgets/order_info.dart';
import 'package:cybex_flutter_plugin/common.dart';
import 'package:cybex_flutter_plugin/order.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class TradePage extends StatefulWidget {
  TradePage({Key key, this.title, this.isUp}) : super(key: key);

  final String title;
  final String isUp;

  @override
  State<StatefulWidget> createState() => _TradeState();
}

class _TradeState extends State<TradePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Palette.backButtonColor, //change your color here
          ),
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
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    Future.delayed(Duration(seconds: 3), () {
                      Navigator.of(context).pop(true);
                    });
                    return DialogFactory.failDialog(context,
                        content: "23 USDT");
                  },
                  barrierDismissible: false,
                );
              },
            )
          ],
          centerTitle: true,
          title: Row(
            children: <Widget>[
              Text("买涨", style: StyleFactory.title),
              SizedBox(
                width: 7,
              ),
              GestureDetector(
                child: ImageFactory.trendSwitch,
                onTap: () {
                  router.navigateTo(context, "/login",
                      transition: TransitionType.inFromRight);
                },
              )
            ],
            mainAxisSize: MainAxisSize.min,
          ),
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
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  children: <Widget>[
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          style: StyleFactory.subTitleStyle,
                          text: "${I18n.of(context).roundEnd} "),
                      TextSpan(
                          style: StyleFactory.cellBoldTitleStyle,
                          text: "05:21"),
                    ])),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          style: StyleFactory.subTitleStyle,
                          text: "${I18n.of(context).nextRoundStart} "),
                      TextSpan(
                          style: StyleFactory.cellBoldTitleStyle,
                          text: "10:21"),
                    ]))
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ),
              Expanded(
                  child: Container(
                decoration: DecorationFactory.cornerShadowDecoration,
                height: double.infinity,
                margin: EdgeInsets.only(top: 1),
              )),
              Container(
                margin: EdgeInsets.only(bottom: 30, top: 20),
                height: 200,
                child: OrderForm(),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 0),
                height: 60,
                child: BuyOrSellBottom(
                    totalAmount: "341.0",
                    feeAmount: "0.0001",
                    balanceAmount: "1000",
                    button: widget.isUp == "buyUp"
                        ? WidgetFactory.button(
                            data: I18n.of(context).buyUp,
                            color: Palette.redOrange,
                            onPressed: () {})
                        : WidgetFactory.button(
                            data: I18n.of(context).buyDown,
                            color: Palette.shamrockGreen,
                            onPressed: () {
                              _openOrder();
                            })),
              )
            ],
          ),
        )));
  }

  _openOrder() {
    RefContractResponseModel refContractResponseModel =
        refDataBloc.subject.value;
    Order order = Order();
    order.chainid = refContractResponseModel.chainId;
    order.refBlockNum = refContractResponseModel.refBlockPrefix;
    order.txExpiration = 600;
    order.fee = AmountToSell(amount: 55, assetId: "1.3.0");
    order.seller = "1.2.30411";
    order.amountToSell = AmountToSell(amount: 20, assetId: "1.3.2");
    order.minToReceive = AmountToSell(amount: 10, assetId: "1.3.3");
    order.expiration = 1800;
    order.fillOrKill = 1;
  }
}

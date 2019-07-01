import 'package:bbb_flutter/helper/order_calculate_helper.dart';
import 'package:bbb_flutter/logic/trade_vm.dart';
import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
import 'package:bbb_flutter/routes/routes.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/widgets/buy_or_sell_bottom.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/market_view.dart';
import 'package:bbb_flutter/widgets/order_form.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api_provider.dart';
import 'package:bbb_flutter/widgets/sparkline.dart';

class TradePage extends StatelessWidget {
  TradePage({Key key, this.params}) : super(key: key);

  final RouteParamsOfTrade params;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => locator<TradeViewModel>(),
      child: Scaffold(
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
                    Navigator.pushNamed(context, RoutePaths.Login);
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
                  child: Consumer2<TickerData, RefContractResponseModel>(
                    builder: (context, current, refdata, child) {
                      Contract refreshContract = refdata.contract
                          .where((c) => c == params.contract)
                          .last;
                      double price = OrderCalculate.calculatePrice(
                          current.value,
                          refreshContract.strikeLevel,
                          refreshContract.conversionRate);
                      return Row(
                        children: <Widget>[
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                style: StyleFactory.subTitleStyle,
                                text: "${I18n.of(context).perPrice}: "),
                            TextSpan(
                                style: StyleFactory.cellBoldTitleStyle,
                                text: "${price.toStringAsFixed(2)} USDT"),
                          ])),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                style: StyleFactory.subTitleStyle,
                                text: "${I18n.of(context).rest}: "),
                            TextSpan(
                                style: StyleFactory.cellBoldTitleStyle,
                                text:
                                    "${refreshContract.availableInventory.toStringAsFixed(0)}"),
                          ]))
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      );
                    },
                  ),
                ),
                Expanded(
                    child: MarketView(
                  isTrade: true,
                  width: ScreenUtil.screenWidthDp - 40,
                )),
                Container(
                  margin: EdgeInsets.only(bottom: 30, top: 20),
                  child: OrderFormWidget(
                    contract: params.contract,
                  ),
                ),
                Consumer<TradeViewModel>(builder: (context, model, child) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 0),
                    height: 60,
                    child: BuyOrSellBottom(
                        totalAmount: model.orderForm.totalAmount.amount,
                        button: params.isUp
                            ? WidgetFactory.button(
                                data: I18n.of(context).buyUp,
                                color: Palette.redOrange,
                                onPressed: () {})
                            : WidgetFactory.button(
                                data: I18n.of(context).buyDown,
                                color: Palette.shamrockGreen,
                                onPressed: () async {
                                  await model.postOrder();
                                })),
                  );
                }),
              ],
            ),
          ))),
    );
  }
}

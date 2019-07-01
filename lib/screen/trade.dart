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
import 'package:logging/logging.dart';

import 'dropdown.dart';

class TradePage extends StatefulWidget {
  TradePage({Key key, this.params}) : super(key: key);

  final RouteParamsOfTrade params;

  @override
  _TradePageState createState() => _TradePageState();
}

class _TradePageState extends State<TradePage> {
  double showDropdownMenuHeight = 0;

  void setDropdownMenuHeight() {
    showDropdownMenuHeight = showDropdownMenuHeight != 0 ? 0 : 316;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) {
        var vm = locator<TradeViewModel>();
        vm.initForm(widget.params.isUp);
        return vm;
      },
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
                  setDropdownMenuHeight();
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
                  child: ImageFactory.icDropdown,
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
          body: Consumer<TradeViewModel>(
            builder: (context, model, child) {
              return Stack(
                children: <Widget>[
                  Container(
                      foregroundDecoration: showDropdownMenuHeight != 0
                          ? BoxDecoration(color: Color(000000).withOpacity(0.4))
                          : null,
                      child: IgnorePointer(
                        ignoring: showDropdownMenuHeight != 0,
                        child: SafeArea(
                            child: Container(
                          margin: Dimen.pageMargin,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Consumer2<TickerData,
                                    RefContractResponseModel>(
                                  builder: (context, current, refdata, child) {
                                    Contract refreshContract = refdata.contract
                                        .where(
                                            (c) => c == widget.params.contract)
                                        .last;
                                    double price =
                                        OrderCalculate.calculatePrice(
                                            current.value,
                                            refreshContract.strikeLevel,
                                            refreshContract.conversionRate);
                                    return Row(
                                      children: <Widget>[
                                        RichText(
                                            text: TextSpan(children: [
                                          TextSpan(
                                              style: StyleFactory.subTitleStyle,
                                              text:
                                                  "${I18n.of(context).perPrice}: "),
                                          TextSpan(
                                              style: StyleFactory
                                                  .cellBoldTitleStyle,
                                              text:
                                                  "${price.toStringAsFixed(2)} USDT"),
                                        ])),
                                        RichText(
                                            text: TextSpan(children: [
                                          TextSpan(
                                              style: StyleFactory.subTitleStyle,
                                              text:
                                                  "${I18n.of(context).rest}: "),
                                          TextSpan(
                                              style: StyleFactory
                                                  .cellBoldTitleStyle,
                                              text:
                                                  "${refreshContract.availableInventory.toStringAsFixed(0)}"),
                                        ]))
                                      ],
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                    );
                                  },
                                ),
                              ),
                              Expanded(
                                child: MarketView(
                                  isTrade: true,
                                  width: ScreenUtil.screenWidthDp - 40,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 30, top: 20),
                                child: OrderFormWidget(
                                    contract: widget.params.contract),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 0),
                                height: 60,
                                child: BuyOrSellBottom(
                                    totalAmount:
                                        model.orderForm.totalAmount.amount,
                                    button: widget.params.isUp
                                        ? WidgetFactory.button(
                                            data: I18n.of(context).buyUp,
                                            color: Palette.redOrange,
                                            onPressed: () async {
                                              try {
                                                await model.postOrder();
                                              } catch (e) {
                                                locator.get<Logger>().severe(e);
                                              }
                                            })
                                        : WidgetFactory.button(
                                            data: I18n.of(context).buyDown,
                                            color: Palette.shamrockGreen,
                                            onPressed: () async {
                                              try {
                                                await model.postOrder();
                                              } catch (e) {
                                                locator.get<Logger>().severe(e);
                                              }
                                            })),
                              ),
                            ],
                          ),
                        )),
                      )),
                  Dropdown(
                      menuHeight: showDropdownMenuHeight,
                      tradeViewModel: model),
                ],
              );
            },
          )),
    );
  }
}

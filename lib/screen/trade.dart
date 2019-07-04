import 'package:bbb_flutter/helper/order_calculate_helper.dart';
import 'package:bbb_flutter/logic/trade_vm.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
import 'package:bbb_flutter/routes/routes.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/widgets/buy_or_sell_bottom.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/market_view.dart';
import 'package:bbb_flutter/widgets/order_form.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api_provider.dart';
import 'package:bbb_flutter/widgets/sparkline.dart';
import 'package:logger/logger.dart';
import 'package:bbb_flutter/routes/routes.dart';
import 'dropdown.dart';

class TradePage extends StatefulWidget {
  TradePage({Key key}) : super(key: key);

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
    final RouteParamsOfTrade params = ModalRoute.of(context).settings.arguments;

    return ChangeNotifierProvider(
      builder: (context) {
        var vm = locator<TradeViewModel>();
        vm.initForm(params.isUp);
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
            title: Consumer<TradeViewModel>(builder: (context, model, child) {
              return Row(
                children: <Widget>[
                  Text(
                      model.orderForm.isUp
                          ? "${I18n.of(context).buyUp}-${model.contract.strikeLevel}"
                          : "${I18n.of(context).buyDown}-${model.contract.strikeLevel}",
                      style: model.orderForm.isUp
                          ? StyleFactory.buyUpTitle
                          : StyleFactory.buyDownTitle),
                SizedBox(
                  width: 7,
                ),
                GestureDetector(
                  child: Image.asset(R.resAssetsIconsIcDropdown),
                  onTap: () {
                    Navigator.pushNamed(context, RoutePaths.Login);
                  },
                )
              ],
              mainAxisSize: MainAxisSize.min,
              );
            }),
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
                                    Contract refreshContract = model.contract;
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
                                child:
                                    OrderFormWidget(contract: params.contract),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 0),
                                height: 60,
                                child: BuyOrSellBottom(
                                    totalAmount:
                                        model.orderForm.totalAmount.amount,
                                    button: model.orderForm.isUp
                                        ? WidgetFactory.button(
                                            data: I18n.of(context).buyUp,
                                            color: Palette.redOrange,
                                            onPressed: () async {
                                              model.saveOrder();
                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  builder: (context) {
                                                    return DialogFactory
                                                        .confirmDialog(context,
                                                            model: model);
                                                  }).then((value) async {
                                                if (value) {
                                                  try {
                                                    await model.postOrder();
                                                  } catch (e) {
                                                locator.get<Logger>().e(e);
                                                  }
                                                }
                                              });
                                            })
                                        : WidgetFactory.button(
                                            data: I18n.of(context).buyDown,
                                            color: Palette.shamrockGreen,
                                            onPressed: () async {
                                              try {
                                                await model.postOrder();
                                              } catch (e) {
                                                locator.get<Logger>().e(e);
                                              }
                                            })),
                              ),
                            ],
                          ),
                        )),
                      )),
                  Dropdown(
                    menuHeight: showDropdownMenuHeight,
                    function: () {
                      setDropdownMenuHeight();
                    },
                  ),
                ],
              );
            },
          )),
    );
  }
}

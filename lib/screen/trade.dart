import 'package:bbb_flutter/base/mixin.dart';
import 'package:bbb_flutter/helper/order_calculate_helper.dart';
import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/logic/trade_vm.dart';
import 'package:bbb_flutter/manager/market_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/post_order_response_model.dart';
import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';
import 'package:bbb_flutter/routes/routes.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/widgets/buy_or_sell_bottom.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/keyboard_scroll_page.dart';
import 'package:bbb_flutter/widgets/market_view.dart';
import 'package:bbb_flutter/widgets/order_form.dart';
import 'package:bbb_flutter/widgets/sparkline.dart';
import 'package:logger/logger.dart';
import 'dropdown.dart';

class TradePage extends StatefulWidget {
  TradePage({Key key}) : super(key: key);

  @override
  _TradePageState createState() => _TradePageState();
}

class _TradePageState extends State<TradePage> with AfterLayoutMixin {
  double showDropdownMenuHeight = 0;
  MarketManager mtm = MarketManager(api: locator.get());

  void setDropdownMenuHeight() {
    showDropdownMenuHeight = showDropdownMenuHeight != 0 ? 0 : 316;
    setState(() {});
  }

  @override
  void afterFirstLayout(BuildContext context) {
    mtm.loadAllData("BXBT");
  }

  @override
  Widget build(BuildContext context) {
    final RouteParamsOfTrade params = ModalRoute.of(context).settings.arguments;
    AppBar appBar = AppBar(
      iconTheme: IconThemeData(
        color: Palette.backButtonColor, //change your color here
      ),
      actions: <Widget>[
        locator.get<UserManager>().user.loginType == LoginType.test
            ? Container()
            : GestureDetector(
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
                  Navigator.of(context).pushNamed(RoutePaths.Deposit);
                },
              )
      ],
      centerTitle: true,
      title: Consumer<TradeViewModel>(builder: (context, model, child) {
        return Row(
          children: <Widget>[
            GestureDetector(
              onTap: () => setDropdownMenuHeight(),
              child: Text(
                  model.orderForm.isUp
                      ? "${I18n.of(context).buyUp}-${model.contract.strikeLevel}"
                      : "${I18n.of(context).buyDown}-${model.contract.strikeLevel}",
                  style: model.orderForm.isUp
                      ? StyleFactory.buyUpTitle
                      : StyleFactory.buyDownTitle),
            ),
            SizedBox(
              width: 7,
            ),
            GestureDetector(
              child: Image.asset(R.resAssetsIconsIcDropdown),
              onTap: () {
                setDropdownMenuHeight();
              },
            )
          ],
          mainAxisSize: MainAxisSize.min,
        );
      }),
      backgroundColor: Colors.white,
      brightness: Brightness.light,
      elevation: 0,
    );
    return ChangeNotifierProvider(
      builder: (context) {
        var vm = locator<TradeViewModel>();
        vm.initForm(params.isUp);
        return vm;
      },
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: appBar,
          body: KeyboardScrollPage(
            appbarHeight: appBar.preferredSize.height,
            widget: Consumer<TradeViewModel>(
              builder: (context, model, child) {
                return Stack(
                  children: <Widget>[
                    Container(
                        foregroundDecoration: showDropdownMenuHeight != 0
                            ? BoxDecoration(
                                color: Color(000000).withOpacity(0.4))
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
                                    builder:
                                        (context, current, refdata, child) {
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
                                                style:
                                                    StyleFactory.subTitleStyle,
                                                text:
                                                    "${I18n.of(context).perPrice}: "),
                                            TextSpan(
                                                style: StyleFactory
                                                    .cellBoldTitleStyle,
                                                text:
                                                    "${price.toStringAsFixed(4)} USDT"),
                                          ])),
                                          RichText(
                                              text: TextSpan(children: [
                                            TextSpan(
                                                style:
                                                    StyleFactory.subTitleStyle,
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
                                  child: MultiProvider(
                                    providers: [
                                      StreamProvider(
                                          builder: (context) => mtm.prices),
                                      StreamProvider(
                                          builder: (context) =>
                                              mtm.lastTicker.stream)
                                    ],
                                    child: MarketView(
                                      isTrade: true,
                                      width: ScreenUtil.screenWidthDp - 40,
                                      mtm: mtm,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 15, top: 20),
                                  child: OrderFormWidget(
                                      contract: params.contract),
                                ),
                                Divider(color: Palette.separatorColor),
                                Container(
                                  margin: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .padding
                                          .bottom),
                                  height: 60,
                                  child: BuyOrSellBottom(
                                      totalAmount:
                                          model.orderForm.totalAmount.amount,
                                      button: model.orderForm.isUp
                                          ? WidgetFactory.button(
                                              topPadding: 8,
                                              bottomPadding: 8,
                                              data: I18n.of(context).buyUp,
                                              color: model.isSatisfied
                                                  ? Palette.redOrange
                                                  : Palette.subTitleColor,
                                              onPressed: model.isSatisfied
                                                  ? () async {
                                                      model.saveOrder();
                                                      TextEditingController
                                                          passwordEditor =
                                                          TextEditingController();
                                                      showDialog(
                                                          context: context,
                                                          barrierDismissible:
                                                              true,
                                                          builder: (context) {
                                                            return DialogFactory
                                                                .confirmDialog(
                                                                    context,
                                                                    model:
                                                                        model,
                                                                    controller:
                                                                        passwordEditor);
                                                          }).then((value) async {
                                                        if (value) {
                                                          callPostOrder(
                                                              context, model);
                                                        }
                                                      });
                                                    }
                                                  : () {})
                                          : WidgetFactory.button(
                                              topPadding: 8,
                                              bottomPadding: 8,
                                              data: I18n.of(context).buyDown,
                                              color: model.isSatisfied
                                                  ? Palette.shamrockGreen
                                                  : Palette.subTitleColor,
                                              onPressed: model.isSatisfied
                                                  ? () async {
                                                      model.saveOrder();
                                                      TextEditingController
                                                          passwordEditor =
                                                          TextEditingController();
                                                      showDialog(
                                                          context: context,
                                                          barrierDismissible:
                                                              true,
                                                          builder: (context) {
                                                            return DialogFactory
                                                                .confirmDialog(
                                                                    context,
                                                                    model:
                                                                        model,
                                                                    controller:
                                                                        passwordEditor);
                                                          }).then((value) async {
                                                        if (value) {
                                                          callPostOrder(
                                                              context, model);
                                                        }
                                                      });
                                                    }
                                                  : () {})),
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
            ),
          )),
    );
  }

  callPostOrder(BuildContext context, TradeViewModel model) async {
    showLoading(context);
    try {
      PostOrderResponseModel postOrderResponseModel = await model.postOrder();
      Navigator.of(context).pop();
      if (postOrderResponseModel.status == "Failed") {
        showToast(context, true, postOrderResponseModel.reason);
      } else {
        showToast(context, false, I18n.of(context).successToast);
      }
    } catch (e) {
      Navigator.of(context).pop();
      showToast(context, true, I18n.of(context).failToast);
      locator.get<Logger>().e(e);
    }
  }
}

import 'package:bbb_flutter/base/mixin.dart';
import 'package:bbb_flutter/helper/order_calculate_helper.dart';
import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/logic/trade_vm.dart';
import 'package:bbb_flutter/manager/market_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/bbb_query_response/contract_response.dart';
import 'package:bbb_flutter/models/response/post_order_response_model.dart';
import 'package:bbb_flutter/routes/routes.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
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
  MarketManager mtm = MarketManager(api: locator.get(), sharedPref: locator.get());

  void setDropdownMenuHeight() {
    showDropdownMenuHeight = showDropdownMenuHeight != 0 ? 0 : 316;
    setState(() {});
  }

  @override
  void afterFirstLayout(BuildContext context) {
    mtm.loadAllData("BXBT");
  }

  @override
  void dispose() {
    mtm.cancelAndRemoveData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final RouteParamsOfTrade params = ModalRoute.of(context).settings.arguments;
    AppBar appBar = AppBar(
      iconTheme: IconThemeData(
        color: Palette.backButtonColor, //change your color here
      ),
      actions: <Widget>[
        // locator.get<UserManager>().user.loginType != LoginType.cloud
        //     ? Container()
        Consumer<TradeViewModel>(
          builder: (context, model, child) {
            return GestureDetector(
              child: Padding(
                padding: EdgeInsets.only(right: 20),
                child: Center(
                  child: Text(
                    I18n.of(context).limitOrder,
                    style: StyleNewFactory.yellowOrange18,
                    textScaleFactor: 1,
                  ),
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, RoutePaths.LimitOrder,
                    arguments: RouteParamsOfTrade(isUp: model.orderForm.isUp, isCoupon: false));
              },
            );
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
                      ? "${I18n.of(context).buyUp}-${model.contract.strikeLevel.toStringAsFixed(0)}"
                      : "${I18n.of(context).buyDown}-${model.contract.strikeLevel.toStringAsFixed(0)}",
                  style:
                      model.orderForm.isUp ? StyleFactory.buyUpTitle : StyleFactory.buyDownTitle),
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
      create: (context) {
        var vm = locator<TradeViewModel>();
        vm.initForm(params.isUp);
        vm.fetchPostion();
        return vm;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
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
                              ? BoxDecoration(color: Color(000000).withOpacity(0.4))
                              : null,
                          child: IgnorePointer(
                            ignoring: showDropdownMenuHeight != 0,
                            child: SafeArea(
                                child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    color: Colors.white,
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 10, right: 15, left: 15),
                                    child: Consumer2<TickerData, ContractResponse>(
                                      builder: (context, current, refdata, child) {
                                        Contract refreshContract = model.contract;
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
                                                  text: "${price.toStringAsFixed(4)} USDT"),
                                            ])),
                                          ],
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        );
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: MultiProvider(
                                      providers: [
                                        StreamProvider(create: (context) => mtm.prices),
                                        StreamProvider(create: (context) => mtm.lastTicker.stream)
                                      ],
                                      child: Container(
                                        margin: EdgeInsets.only(top: 10),
                                        child: MarketView(
                                          isTrade: true,
                                          width: ScreenUtil.screenWidthDp - 40,
                                          mtm: mtm,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: Colors.white,
                                    padding: EdgeInsets.only(bottom: 12),
                                    margin: EdgeInsets.only(bottom: 10, top: 10),
                                    child: OrderFormWidget(contract: model.contract),
                                  ),
                                  Container(
                                      color: Colors.white,
                                      margin: EdgeInsets.only(
                                          bottom: MediaQuery.of(context).padding.bottom),
                                      padding: EdgeInsets.only(left: 15),
                                      child: BuyOrSellBottom(
                                          totalAmount: model.orderForm.totalAmount.amount,
                                          button: model.orderForm.isUp
                                              ? GestureDetector(
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    padding: EdgeInsets.only(top: 12, bottom: 12),
                                                    child: new Text(
                                                      "开仓",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.white),
                                                    ),
                                                    width: 130,
                                                    color: model.isSatisfied
                                                        ? Palette.redOrange
                                                        : Palette.subTitleColor,
                                                  ),
                                                  onTap: model.isSatisfied
                                                      ? () async {
                                                          onConfirmClicked(model: model);
                                                        }
                                                      : () {})
                                              : GestureDetector(
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    padding: EdgeInsets.only(top: 12, bottom: 12),
                                                    child: new Text(
                                                      "开仓",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.white),
                                                    ),
                                                    width: 130,
                                                    color: model.isSatisfied
                                                        ? Palette.shamrockGreen
                                                        : Palette.subTitleColor,
                                                  ),
                                                  onTap: model.isSatisfied
                                                      ? () async {
                                                          onConfirmClicked(model: model);
                                                        }
                                                      : () {},
                                                ))),
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
      ),
    );
  }

  onConfirmClicked({TradeViewModel model}) {
    if (locator.get<UserManager>().user.loginType == LoginType.cloud &&
        model.orderForm.cybBalance.quantity < (AssetDef.cybTransfer.amount / 100000)) {
      showNotification(context, true, I18n.of(context).noFeeError);
    } else {
      bool shouldShowAlertBuyUp = model.orderForm.isUp &&
          ((model.orderForm.takeProfitPx != null &&
                  model.orderForm.takeProfitPx != 0 &&
                  model.orderForm.takeProfitPx < model.currentTicker.value) ||
              (model.orderForm.cutoffPx != null &&
                  (model.orderForm.cutoffPx > model.currentTicker.value)));

      bool shouldShowAlertBuyDown = !model.orderForm.isUp &&
          ((model.orderForm.takeProfitPx != null &&
                  model.orderForm.takeProfitPx != 0 &&
                  model.orderForm.takeProfitPx > model.currentTicker.value) ||
              (model.orderForm.cutoffPx != null &&
                  (model.orderForm.cutoffPx < model.currentTicker.value)));

      if (shouldShowAlertBuyUp || shouldShowAlertBuyDown) {
        showDialog(
            context: context,
            builder: (context) {
              return DialogFactory.normalConfirmDialog(context,
                  title: I18n.of(context).remider,
                  content: I18n.of(context).triggerCloseContent, onConfirmPressed: () {
                _onDialogConfirmClicked(model: model);
              });
            });
      } else {
        _onDialogConfirmClicked(model: model);
      }
    }
  }

  _onDialogConfirmClicked({TradeViewModel model}) {
    model.saveOrder();
    TextEditingController passwordEditor = TextEditingController();
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return DialogFactory.confirmDialog(context, controller: passwordEditor);
        }).then((value) async {
      if (value != null && value) {
        callPostOrder(context, model);
      }
    });
  }

  callPostOrder(BuildContext context, TradeViewModel model) async {
    showLoading(context, isBarrierDismissible: false);
    try {
      PostOrderResponseModel postOrderResponseModel = await model.postOrder();
      if (postOrderResponseModel.code != 0) {
        Navigator.of(context).pop();
        showNotification(context, true, postOrderResponseModel.msg);
      } else {
        await model.fetchPostion();
        Navigator.of(context).pop();
        showNotification(context, false, I18n.of(context).successToast, callback: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        });
      }
    } catch (e) {
      Navigator.of(context).pop();
      showNotification(context, true, I18n.of(context).failToast);
      locator.get<Logger>().e(e);
    }
  }
}

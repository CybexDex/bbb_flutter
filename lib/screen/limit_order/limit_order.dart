import 'package:bbb_flutter/base/mixin.dart';
import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/logic/limit_order_vm.dart';
import 'package:bbb_flutter/manager/market_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/post_order_response_model.dart';
import 'package:bbb_flutter/routes/routes.dart';
import 'package:bbb_flutter/screen/limit_order/limit_order_form.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/widgets/buy_or_sell_bottom.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/keyboard_scroll_page.dart';
import 'package:bbb_flutter/widgets/market_view.dart';
import 'package:logger/logger.dart';

class LimitOrderPage extends StatefulWidget {
  LimitOrderPage({Key key}) : super(key: key);

  @override
  _LimitOrderPageState createState() => _LimitOrderPageState();
}

class _LimitOrderPageState extends State<LimitOrderPage> with AfterLayoutMixin {
  double showDropdownMenuHeight = 0;
  MarketManager mtm =
      MarketManager(api: locator.get(), sharedPref: locator.get());

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
        locator.get<UserManager>().user.loginType != LoginType.cloud
            ? Container()
            : GestureDetector(
                child: Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Center(
                    child: Text(
                      I18n.of(context).topUp,
                      style: StyleNewFactory.yellowOrange18,
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
      title: Consumer<LimitOrderViewModel>(builder: (context, model, child) {
        return Row(
          children: <Widget>[
            GestureDetector(
              onTap: model.updateSide,
              child: Text(
                  model.orderForm.isUp
                      ? "${I18n.of(context).buyUp}"
                      : "${I18n.of(context).buyDown}",
                  style: model.orderForm.isUp
                      ? StyleFactory.buyUpTitle
                      : StyleFactory.buyDownTitle),
            ),
            SizedBox(
              width: 7,
            ),
            GestureDetector(
              child: Icon(Icons.swap_vert,
                  color: model.orderForm.isUp
                      ? Palette.redOrange
                      : Palette.shamrockGreen),
              onTap: model.updateSide,
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
        var vm = locator<LimitOrderViewModel>();
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
              widget: Consumer<LimitOrderViewModel>(
                builder: (context, model, child) {
                  return Stack(
                    children: <Widget>[
                      Container(
                          child: IgnorePointer(
                        ignoring: showDropdownMenuHeight != 0,
                        child: SafeArea(
                            child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                child: MultiProvider(
                                  providers: [
                                    StreamProvider(
                                        create: (context) => mtm.prices),
                                    StreamProvider(
                                        create: (context) =>
                                            mtm.lastTicker.stream)
                                  ],
                                  child: Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: MarketView(
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
                                child: LimitOrderFormWidget(model: model),
                              ),
                              Container(
                                  color: Colors.white,
                                  margin: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .padding
                                          .bottom),
                                  padding: EdgeInsets.only(left: 15),
                                  child: BuyOrSellBottom(
                                      totalAmount:
                                          model.orderForm.totalAmount.amount,
                                      button: model.orderForm.isUp
                                          ? GestureDetector(
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.only(
                                                    top: 12, bottom: 12),
                                                child: new Text(
                                                  I18n.of(context).buyUp,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white),
                                                ),
                                                width: 130,
                                                color: model.isSatisfied &&
                                                        model.orderForm
                                                                .predictPrice !=
                                                            null &&
                                                        model.contract !=
                                                            null &&
                                                        model.orderForm
                                                                .predictPrice !=
                                                            model.ticker.value
                                                    ? Palette.redOrange
                                                    : Palette.subTitleColor,
                                              ),
                                              onTap: model.isSatisfied &&
                                                      model.orderForm
                                                              .predictPrice !=
                                                          null &&
                                                      model.contract != null &&
                                                      model.orderForm
                                                              .predictPrice !=
                                                          model.ticker.value
                                                  ? () async {
                                                      onConfirmClicked(
                                                          model: model);
                                                    }
                                                  : () {})
                                          : GestureDetector(
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.only(
                                                    top: 12, bottom: 12),
                                                child: new Text(
                                                  I18n.of(context).buyDown,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white),
                                                ),
                                                width: 130,
                                                color: model.isSatisfied &&
                                                        model.orderForm
                                                                .predictPrice !=
                                                            null &&
                                                        model.contract !=
                                                            null &&
                                                        model.orderForm
                                                                .predictPrice !=
                                                            model.ticker.value
                                                    ? Palette.shamrockGreen
                                                    : Palette.subTitleColor,
                                              ),
                                              onTap: model.isSatisfied &&
                                                      model.orderForm
                                                              .predictPrice !=
                                                          null &&
                                                      model.contract != null &&
                                                      model.orderForm
                                                              .predictPrice !=
                                                          model.ticker.value
                                                  ? () async {
                                                      onConfirmClicked(
                                                          model: model);
                                                    }
                                                  : () {},
                                            ))),
                            ],
                          ),
                        )),
                      )),
                    ],
                  );
                },
              ),
            )),
      ),
    );
  }

  onConfirmClicked({LimitOrderViewModel model}) {
    if (locator.get<UserManager>().user.loginType == LoginType.cloud &&
        model.orderForm.cybBalance.quantity <
            (AssetDef.cybTransfer.amount / 100000)) {
      showNotification(context, true, I18n.of(context).noFeeError);
    } else {
      _onDialogConfirmClicked(model: model);
    }
  }

  _onDialogConfirmClicked({LimitOrderViewModel model}) {
    TextEditingController passwordEditor = TextEditingController();
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return DialogFactory.confirmDialog(context,
              model: model, controller: passwordEditor);
        }).then((value) async {
      if (value) {
        callPostOrder(context, model);
      }
    });
  }

  callPostOrder(BuildContext context, LimitOrderViewModel model) async {
    showLoading(context, isBarrierDismissible: false);
    try {
      PostOrderResponseModel postOrderResponseModel = await model.postOrder();
      Navigator.of(context).pop();
      if (postOrderResponseModel.code != 0) {
        showNotification(context, true, postOrderResponseModel.msg);
      } else {
        await model.fetchPostion();
        showNotification(context, false, I18n.of(context).successToast,
            callback: () {
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

import 'package:bbb_flutter/cache/shared_pref.dart';
import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/logic/limit_order_vm.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/post_order_response_model.dart';
import 'package:bbb_flutter/models/response/websocket_nx_daily_px_response.dart';
import 'package:bbb_flutter/screen/limit_order/limit_order_form.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/buy_or_sell_bottom.dart';
import 'package:bbb_flutter/widgets/keyboard_scroll_page.dart';
import 'package:bbb_flutter/widgets/sparkline.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';

class TradeUSDTPage extends StatefulWidget {
  TradeUSDTPage({Key key}) : super(key: key);
  @override
  TradeUSDTPageState createState() {
    return TradeUSDTPageState();
  }
}

class TradeUSDTPageState extends State<TradeUSDTPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: KeyboardScrollPage(
            appbarHeight: 0,
            widget: Consumer3<LimitOrderViewModel, TickerData, WebSocketNXDailyPxResponse>(
              builder: (context, model, ticker, dailyPx, child) {
                double percentage = (ticker != null && dailyPx != null)
                    ? (((ticker.value - dailyPx.lastDayPx) / dailyPx.lastDayPx) * 100)
                    : 0;
                return SafeArea(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                          top: ScreenUtil.getInstance().setHeight(15),
                          left: ScreenUtil.getInstance().setWidth(15),
                          right: ScreenUtil.getInstance().setWidth(15)),
                      child: Column(
                        children: <Widget>[
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text("${locator.get<SharedPref>().getAsset()}/USDT",
                                  style: StyleNewFactory.grey14)),
                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(5),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(ticker?.value?.toStringAsFixed(4) ?? "--",
                                      style: percentage >= 0
                                          ? StyleNewFactory.red27
                                          : StyleNewFactory.green27),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  percentage >= 0
                                      ? SvgPicture.asset(
                                          R.resAssetsIconsIcWithdraw,
                                          color: Palette.appRed,
                                          height: 20,
                                          width: 14,
                                        )
                                      : SvgPicture.asset(
                                          R.resAssetsIconsIcDeposit,
                                          color: Palette.appGreen,
                                          height: 20,
                                          width: 14,
                                        )
                                ],
                              ),
                              Text(percentage == 0 ? "--" : "${percentage.toStringAsFixed(2)}%",
                                  style: percentage >= 0
                                      ? StyleNewFactory.red27
                                      : StyleNewFactory.green27)
                            ],
                          ),
                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(1),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(I18n.of(context).exchange24High,
                                      style: StyleNewFactory.grey14),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(dailyPx?.highPx?.toStringAsFixed(2) ?? "--",
                                      style: StyleNewFactory.grey14)
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text(I18n.of(context).exchange24Low,
                                      style: StyleNewFactory.grey14),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(dailyPx?.lowPx?.toStringAsFixed(2) ?? "--",
                                      style: StyleNewFactory.grey14)
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(15)),
                      child: LimitOrderFormWidget(model: model),
                    ),
                    Container(
                      color: Palette.separatorColor,
                      height: ScreenUtil.getInstance().setHeight(0.5),
                    ),
                    Container(
                        color: Colors.white,
                        margin: EdgeInsets.only(
                            bottom: ScreenUtil.getInstance()
                                .setHeight(MediaQuery.of(context).padding.bottom)),
                        padding: EdgeInsets.only(left: 15),
                        child: BuyOrSellBottom(
                            totalAmount: model.orderForm.totalAmount.amount,
                            button: model.orderForm.isUp
                                ? GestureDetector(
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(
                                          top: ScreenUtil.getInstance().setHeight(8),
                                          bottom: ScreenUtil.getInstance().setHeight(8)),
                                      child: new Text(
                                        "下单",
                                        style: StyleNewFactory.white18,
                                      ),
                                      width: ScreenUtil.getInstance().setWidth(130),
                                      color: (model.isMarket && model.isSatisfied) ||
                                              (model.isSatisfied &&
                                                  model.orderForm.predictPrice != null &&
                                                  model.contract != null &&
                                                  model.orderForm.predictPrice !=
                                                      model.ticker.value)
                                          ? Palette.redOrange
                                          : Palette.subTitleColor,
                                    ),
                                    onTap: (model.isMarket && model.isSatisfied) ||
                                            (model.isSatisfied &&
                                                model.orderForm.predictPrice != null &&
                                                model.contract != null &&
                                                model.orderForm.predictPrice != model.ticker.value)
                                        ? () async {
                                            onConfirmClicked(model: model);
                                          }
                                        : () {})
                                : GestureDetector(
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(
                                          top: ScreenUtil.getInstance().setHeight(8),
                                          bottom: ScreenUtil.getInstance().setHeight(8)),
                                      child: new Text(
                                        "下单",
                                        style: StyleNewFactory.white18,
                                      ),
                                      width: ScreenUtil.getInstance().setWidth(130),
                                      color: (model.isMarket && model.isSatisfied) ||
                                              (model.isSatisfied &&
                                                  model.orderForm.predictPrice != null &&
                                                  model.contract != null &&
                                                  model.orderForm.predictPrice !=
                                                      model.ticker.value)
                                          ? Palette.shamrockGreen
                                          : Palette.subTitleColor,
                                    ),
                                    onTap: (model.isMarket && model.isSatisfied) ||
                                            (model.isSatisfied &&
                                                model.orderForm.predictPrice != null &&
                                                model.contract != null &&
                                                model.orderForm.predictPrice != model.ticker.value)
                                        ? () async {
                                            onConfirmClicked(model: model);
                                          }
                                        : () {},
                                  ))),
                  ],
                ));
              },
            )));
  }

  onConfirmClicked({LimitOrderViewModel model}) {
    if (locator.get<UserManager>().user.loginType == LoginType.cloud &&
        model.orderForm.cybBalance.quantity < (AssetDef.cybTransfer.amount / 100000)) {
      showNotification(context, true, I18n.of(context).noFeeError);
    } else {
      bool shouldShowAlertBuyUp = model.orderForm.isUp &&
          ((model.orderForm.takeProfitPx != null &&
                  model.orderForm.takeProfitPx != 0 &&
                  model.orderForm.takeProfitPx <
                      (model.isMarket
                          ? model.currentTicker.value
                          : model.orderForm.predictPrice)) ||
              (model.orderForm.cutoffPx != null &&
                  (model.orderForm.cutoffPx >
                      (model.isMarket
                          ? model.currentTicker.value
                          : model.orderForm.predictPrice))));

      bool shouldShowAlertBuyDown = !model.orderForm.isUp &&
          ((model.orderForm.takeProfitPx != null &&
                  model.orderForm.takeProfitPx != 0 &&
                  model.orderForm.takeProfitPx >
                      (model.isMarket
                          ? model.currentTicker.value
                          : model.orderForm.predictPrice)) ||
              (model.orderForm.cutoffPx != null &&
                  (model.orderForm.cutoffPx <
                      (model.isMarket
                          ? model.currentTicker.value
                          : model.orderForm.predictPrice))));

      if (shouldShowAlertBuyUp || shouldShowAlertBuyDown) {
        showDialog(
            context: context,
            builder: (context) {
              return DialogFactory.normalConfirmDialog(context,
                  title: I18n.of(context).remider,
                  content: model.isMarket
                      ? I18n.of(context).triggerCloseContent
                      : I18n.of(context).triggerCloseLimitContent, onConfirmPressed: () {
                _onDialogConfirmClicked(model: model);
              });
            });
      } else {
        _onDialogConfirmClicked(model: model);
      }
    }
  }

  _onDialogConfirmClicked({LimitOrderViewModel model}) {
    if (model.isMarket) {
      model.saveMarketOrder();
    }
    TextEditingController passwordEditor = TextEditingController();
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return DialogFactory.confirmDialog(context, model: model, controller: passwordEditor,
              onConfirmed: () async {
            showUnlockAndBiometricDialog(
                context: context,
                passwordEditor: passwordEditor,
                callback: () => Navigator.of(context, rootNavigator: true).pop(true));
          });
        }).then((value) async {
      if (value != null && value) {
        await callPostOrder(context, model);
      }
    });
  }

  callPostOrder(BuildContext context, LimitOrderViewModel model) async {
    showLoading(context, isBarrierDismissible: false);
    try {
      PostOrderResponseModel postOrderResponseModel =
          model.isMarket ? await model.postMarketOrder() : await model.postOrder();
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

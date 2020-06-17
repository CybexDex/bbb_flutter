import 'package:bbb_flutter/cache/shared_pref.dart';
import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/logic/coupon_order_view_model.dart';
import 'package:bbb_flutter/models/response/post_order_response_model.dart';
import 'package:bbb_flutter/models/response/websocket_nx_daily_px_response.dart';
import 'package:bbb_flutter/screen/trade/coupon_order_form.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/buy_or_sell_bottom.dart';
import 'package:bbb_flutter/widgets/keyboard_scroll_page.dart';
import 'package:bbb_flutter/widgets/sparkline.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';

class TradeCouponPage extends StatefulWidget {
  TradeCouponPage({Key key}) : super(key: key);

  @override
  TradeCouponState createState() {
    return TradeCouponState();
  }
}

class TradeCouponState extends State<TradeCouponPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: KeyboardScrollPage(
          appbarHeight: 0,
          widget: Consumer3<CouponOrderViewModel, TickerData, WebSocketNXDailyPxResponse>(
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
                                        color: Palette.shamrockGreen,
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
                                Text(I18n.of(context).exchange24Low, style: StyleNewFactory.grey14),
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
                    child: CouponOrderForm(model: model),
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
                          totalAmount: model.couponAmount * model.amountPerContract,
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
                                    color: model.isSatisfied && model.selectedCoupon != null
                                        ? Palette.redOrange
                                        : Palette.subTitleColor,
                                  ),
                                  onTap: model.isSatisfied && model.selectedCoupon != null
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
                                    color: model.isSatisfied && model.selectedCoupon != null
                                        ? Palette.shamrockGreen
                                        : Palette.subTitleColor,
                                  ),
                                  onTap: model.isSatisfied && model.selectedCoupon != null
                                      ? () async {
                                          onConfirmClicked(model: model);
                                        }
                                      : () {},
                                ))),
                ],
              ));
            },
          ),
        ));
  }

  onConfirmClicked({CouponOrderViewModel model}) {
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

  _onDialogConfirmClicked({CouponOrderViewModel model}) {
    model.saveMarketOrder();
    TextEditingController passwordEditor = TextEditingController();
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return DialogFactory.confirmDialog(context, model: model, controller: passwordEditor,
              onConfirmed: () {
            showUnlockAndBiometricDialog(
                context: context,
                passwordEditor: passwordEditor,
                callback: () => Navigator.of(context, rootNavigator: true).pop(true));
          });
        }).then((value) async {
      if (value) {
        callPostOrder(context, model);
      }
    });
  }

  callPostOrder(BuildContext context, CouponOrderViewModel model) async {
    showLoading(context, isBarrierDismissible: false);
    try {
      PostOrderResponseModel postOrderResponseModel = await model.postMarketOrder();
      if (postOrderResponseModel.code != 0) {
        Navigator.of(context).pop();
        showNotification(context, true, postOrderResponseModel.msg);
      } else {
        await model.fetchCouponBalance();
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

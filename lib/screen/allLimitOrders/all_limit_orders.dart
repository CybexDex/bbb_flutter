import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/manager/limit_order_manager.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/post_order_response_model.dart';
import 'package:bbb_flutter/shared/palette.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/empty_order.dart';
import 'package:bbb_flutter/widgets/liimit_order_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AllLimitOrderPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AllLimitOrderState();
}

class AllLimitOrderState extends State<AllLimitOrderPage> {
  @override
  void initState() {
    super.initState();
  }

  bool isSelect = false;

  @override
  Widget build(BuildContext context) {
    return BaseWidget<LimitOrderManager>(
      model: LimitOrderManager(
          api: locator.get(),
          um: locator.get(),
          rm: locator.get(),
          tm: locator.get()),
      builder: (context, data, child) {
        return Scaffold(
          body: SafeArea(
            child: data.orders.isEmpty
                ? EmptyOrder(isLimit: true)
                : Column(
                    children: <Widget>[
                      new Expanded(
                          child: Container(
                              child: new ListView(
                                children: _itemView(data),
                                padding: new EdgeInsets.only(bottom: 10),
                              ),
                              width: double.infinity,
                              color: Color(0xfff6f6f6))),
                      Row(
                        children: <Widget>[
                          new Checkbox(
                              value: data.isSelected,
                              activeColor: Palette.invitePromotionBadgeColor,
                              onChanged: (bool) {
                                data.selectAll();
                              }),
                          Text(
                            "全选",
                            style: TextStyle(color: Colors.black, fontSize: 12),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: data.selectedTotalCount > 0
                                      ? () {
                                          TextEditingController controller =
                                              TextEditingController();
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return DialogFactory
                                                    .normalConfirmDialog(
                                                        context,
                                                        title: I18n.of(context)
                                                            .limitOrderCancelButton,
                                                        content: "是否撤单",
                                                        onConfirmPressed: () {
                                                  if (locator
                                                      .get<UserManager>()
                                                      .user
                                                      .isLocked) {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return DialogFactory
                                                              .unlockDialog(
                                                                  context,
                                                                  controller:
                                                                      controller);
                                                        }).then((value) async {
                                                      if (value) {
                                                        cancelAll(data);
                                                      }
                                                    });
                                                  } else {
                                                    cancelAll(data);
                                                  }
                                                });
                                              });
                                        }
                                      : () {},
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: new Text(
                                        "${I18n.of(context).limitOrderCancelButton}(${data.selectedTotalCount}/${data.orders.length})",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      width: 130,
                                      height: 50,
                                      color: data.selectedTotalCount > 0
                                          ? Palette.invitePromotionBadgeColor
                                          : Palette.separatorColor),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
          ),
        );
      },
    );
  }

  List<Widget> _itemView(LimitOrderManager limitOrderManager) {
    List<Widget> listWidget = List();
    for (var i = 0; i < limitOrderManager.orders.length; i++) {
      var item = limitOrderManager.selectedOrders[i].isSelected;
      listWidget.add(new Container(
        color: Colors.white,
        margin: new EdgeInsets.only(top: 10),
        child: Column(
          children: _itemViewChild(i, item, limitOrderManager),
        ),
      ));
    }
    return listWidget;
  }

  List<Widget> _itemViewChild(
      int index, bool item, LimitOrderManager orderViewModel) {
    var row = new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          height: 20,
          width: 20,
          margin: EdgeInsets.all(15),
          child: new Checkbox(
              value: item,
              activeColor: Palette.invitePromotionBadgeColor,
              onChanged: (bool) {
                orderViewModel.selectedOrders[index].isSelected = !item;
                orderViewModel.isSelected = orderViewModel.isAllSeleted();
                orderViewModel.calculateMoneyCount();
              }),
        ),
      ],
    );
    List<Widget> listWidget = List();
    listWidget.clear();
    listWidget.add(row);
    listWidget.add(new Baseline(
      baseline: 1,
      baselineType: TextBaseline.alphabetic,
      child: new Container(
        color: Color(0xFFededed),
        height: 1,
        width: double.infinity,
      ),
    ));

    listWidget.add(Container(
        height: 230,
        width: ScreenUtil.screenWidth,
        child: LimitOrderInfo(
          model: orderViewModel.orders[index],
        )));
    return listWidget;
  }

  cancelAll(LimitOrderManager limitOrderManager) async {
    var failCount = 0;
    var sucessCount = 0;
    try {
      showLoading(context, isBarrierDismissible: false);
      List<Future<PostOrderResponseModel>> futures = [];
      for (int i = 0; i < limitOrderManager.orders.length; i++) {
        if (limitOrderManager.selectedOrders[i].isSelected) {
          futures
              .add(limitOrderManager.cancelOrder(limitOrderManager.orders[i]));
        }
      }
      List<PostOrderResponseModel> postOrderResponseList =
          await Future.wait(futures);
      Navigator.of(context).pop();

      for (var i in postOrderResponseList) {
        if (i.code != 0) {
          failCount++;
        } else {
          sucessCount++;
        }
      }
      if (failCount != 0 && sucessCount != 0) {
        showNotification(context, true, "部分撤单");
      } else if (failCount == 0) {
        showNotification(
            context, false, I18n.of(context).limitOrderCancelSucess,
            callback: () {
          Navigator.of(context).pop();
        });
      } else {
        showNotification(context, true, I18n.of(context).limitOrderCancelFailed,
            callback: () {
          Navigator.of(context).pop();
        });
      }
    } catch (error) {
      Navigator.of(context).pop();
      showNotification(context, true, I18n.of(context).limitOrderCancelFailed,
          callback: () {
        Navigator.of(context).pop();
      });
    }
  }
}

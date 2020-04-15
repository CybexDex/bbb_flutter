import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/helper/ui_utils.dart';
import 'package:bbb_flutter/logic/order_vm.dart';
import 'package:bbb_flutter/logic/pnl_vm.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/post_order_response_model.dart';
import 'package:bbb_flutter/shared/palette.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/empty_order.dart';
import 'package:bbb_flutter/widgets/order_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';

class AllOrdersPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new AllOrderState();
}

class AllOrderState extends State<AllOrdersPage> {
  @override
  void initState() {
    super.initState();
  }

  bool isSelect = false;

  @override
  Widget build(BuildContext context) {
    return BaseWidget<OrderViewModel>(
      model: OrderViewModel(
          api: locator.get(), um: locator.get(), rm: locator.get(), tm: locator.get()),
      builder: (context, data, child) {
        return Scaffold(
          // appBar: AppBar(
          //   iconTheme: IconThemeData(
          //     color: Palette.backButtonColor, //change your color here
          //   ),
          //   centerTitle: true,
          //   title: Text(I18n.of(context).holdAll, style: StyleFactory.title),
          //   backgroundColor: Colors.white,
          //   brightness: Brightness.light,
          //   elevation: 0,
          // ),
          body: SafeArea(
            child: data.orders.isEmpty
                ? EmptyOrder(
                    message: I18n.of(context).orderEmpty,
                  )
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
                                data.calculateMoneyCount();
                              }),
                          Text(
                            "全选",
                            style: TextStyle(color: Colors.black, fontSize: 12),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  "总收益:",
                                  style: TextStyle(color: Colors.black, fontSize: 12),
                                ),
                                Text(
                                  data.selectedTotalPnl.toStringAsFixed(4),
                                  style: TextStyle(
                                    color: data.selectedTotalPnl > 0
                                        ? Palette.redOrange
                                        : Palette.shamrockGreen,
                                    fontSize: 16,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: data.selectedTotalCount > 0
                                      ? () {
                                          TextEditingController controller =
                                              TextEditingController();
                                          if (locator.get<UserManager>().user.isLocked) {
                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (context) {
                                                  return DialogFactory.unlockDialog(context,
                                                      controller: controller);
                                                }).then((value) async {
                                              if (value != null && value) {
                                                showCloseOutDialog(context, controller, data);
                                              }
                                            });
                                          } else {
                                            showCloseOutDialog(context, controller, data);
                                          }
                                        }
                                      : () {},
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: new Text(
                                        "${I18n.of(context).closeOut}(${data.selectedTotalCount}/${data.orders.length})",
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

  List<Widget> _itemView(OrderViewModel orderViewModel) {
    List<Widget> listWidget = List();
    for (var i = 0; i < orderViewModel.orders.length; i++) {
      var item = orderViewModel.selectedOrders[i].isSelected;
      listWidget.add(new Container(
        color: Colors.white,
        margin: new EdgeInsets.only(top: 10),
        child: Column(
          children: _itemViewChild(i, item, orderViewModel),
        ),
      ));
    }
    return listWidget;
  }

  List<Widget> _itemViewChild(int index, bool item, OrderViewModel orderViewModel) {
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
        GestureDetector(
          onTap: () {
            openDialog(context, orderViewModel.orders[index]);
          },
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(right: 9),
                child: Text(I18n.of(context).resetPnl,
                    style: TextStyle(
                      fontFamily: 'PingFangSC',
                      color: Color(0xff282c35),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                    )),
              ),
              SvgPicture.asset(R.resAssetsIconsIcReviseYellow, width: 16, height: 16),
              SizedBox(
                width: 15,
              ),
            ],
          ),
        )
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
        child: OrderInfo(
          model: orderViewModel.orders[index],
          isAll: true,
        )));
    return listWidget;
  }

  showCloseOutDialog(BuildContext context, TextEditingController controller, OrderViewModel data) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return DialogFactory.closeOutConfirmDialog(context,
              value: data.selectedTotalPnl.toStringAsFixed(4), controller: controller);
        }).then((value) async {
      if (value != null && value) {
        callAmendAll(data);
      }
    });
  }

  callAmendAll(OrderViewModel orderViewModel) async {
    var pnl = PnlViewModel(
        api: locator.get(), um: locator.get(), mtm: locator.get(), refm: locator.get());
    var failCount = 0;
    var sucessCount = 0;
    try {
      showLoading(context, isBarrierDismissible: false);
      List<Future<PostOrderResponseModel>> futures = [];
      for (int i = 0; i < orderViewModel.orders.length; i++) {
        if (orderViewModel.selectedOrders[i].isSelected) {
          futures.add(pnl.amend(orderViewModel.orders[i], true, false));
        }
      }
      List<PostOrderResponseModel> postOrderResponseList = await Future.wait(futures);
      Navigator.of(context).pop();

      for (var i in postOrderResponseList) {
        if (i.code != 0) {
          failCount++;
        } else {
          sucessCount++;
        }
      }
      if (failCount != 0 && sucessCount != 0) {
        showNotification(context, true, "部分平仓");
      } else if (failCount == 0) {
        showNotification(context, false, I18n.of(context).closeOut + I18n.of(context).successToast);
      } else {
        showNotification(context, true, I18n.of(context).closeOut + I18n.of(context).failToast);
      }
    } catch (error) {
      Navigator.of(context).pop();
      showNotification(context, true, I18n.of(context).closeOut + I18n.of(context).failToast);
    }
  }
}

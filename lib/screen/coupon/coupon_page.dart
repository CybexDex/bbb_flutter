import 'package:bbb_flutter/helper/utils.dart';
import 'package:bbb_flutter/logic/coupon_vm.dart';
import 'package:bbb_flutter/models/response/bbb_query_response/coupon_response.dart';
import 'package:bbb_flutter/routes/routes.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/empty_order.dart';
import 'package:bbb_flutter/widgets/material_segmented_control.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/svg.dart';

class CouponPage extends StatefulWidget {
  CouponPage({Key key}) : super(key: key);

  @override
  CouponState createState() => CouponState();
}

class CouponState extends State<CouponPage> {
  int _currentSelection = 0;
  @override
  void initState() {
    locator.get<CouponViewModel>().getCoupons();
    locator.get<CouponViewModel>().getUsedCoupons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            actions: <Widget>[
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, RoutePaths.WebView, arguments: {
                  "title": I18n.of(context).couponRule,
                  "url": 'https://nxapi.cybex.io/v1/webpage/coupon_rule.html'
                }),
                child: Container(
                  margin: EdgeInsets.only(right: 15),
                  alignment: Alignment.center,
                  child: Text(
                    "使用规则",
                    style: StyleNewFactory.grey15,
                  ),
                ),
              )
            ],
            iconTheme: IconThemeData(
              color: Palette.backButtonColor, //change your color here
            ),
            centerTitle: true,
            title: Text(I18n.of(context).coupon, style: StyleFactory.title),
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: Container(
                color: Palette.appDividerBackgroudGreyColor,
                height: 6,
              ),
            )),
        body: Consumer<CouponViewModel>(
          builder: (context, model, child) {
            return CustomScrollView(
              slivers: <Widget>[
                SliverStickyHeader(
                  header: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      color: Colors.white,
                      width: ScreenUtil.screenWidth,
                      padding: EdgeInsets.only(
                          left: ScreenUtil.getInstance().setWidth(50),
                          top: ScreenUtil.getInstance().setHeight(10)),
                      child: MaterialSegmentedControl(
                        children: _children,
                        selectionIndex: _currentSelection,
                        borderColor: Palette.appYellowOrange,
                        selectedColor: Palette.appYellowOrange,
                        unselectedColor: Colors.white,
                        borderRadius: 24.0,
                        onSegmentChosen: (index) {
                          setState(() {
                            _currentSelection = index;
                          });
                        },
                      ),
                    ),
                  ),
                  sliver: _currentSelection == 0
                      ? (model.pendingCoupon.length == 0
                          ? SliverFillViewport(
                              delegate: SliverChildBuilderDelegate((context, index) {
                                return EmptyOrder(
                                  message: "暂无奖励金",
                                );
                              }, childCount: 1),
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate((context, index) {
                              return model.pendingCoupon[index].custom == null
                                  ? Container()
                                  : buildPendingItem(coupon: model.pendingCoupon[index]);
                            }, childCount: model.pendingCoupon.length)))
                      : (model.usedCoupon.length == 0
                          ? SliverFillViewport(
                              delegate: SliverChildBuilderDelegate((context, index) {
                                return EmptyOrder(
                                  message: I18n.of(context).recordEmpty,
                                );
                              }, childCount: 1),
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate((context, index) {
                              return model.usedCoupon[index].custom == null
                                  ? Container()
                                  : buildUsedItems(coupon: model.usedCoupon[index]);
                            }, childCount: model.usedCoupon.length))),
                ),
              ],
            );
          },
        ));
  }

  Map<int, Widget> _children = {
    0: Container(
        padding: EdgeInsets.only(
            left: ScreenUtil.getInstance().setWidth(40),
            right: ScreenUtil.getInstance().setWidth(40)),
        child: Text('待使用')),
    1: Container(child: Text('记录'))
  };

  List<Widget> _getWords(String text, TextStyle style) {
    var emoji = RegExp(r"([\u2200-\u3300]|[\uD83C-\uD83E].)");
    List<Widget> res = [];
    var words = text.split(" ");
    for (var word in words) {
      var matches = emoji.allMatches(word);
      if (matches.isEmpty) {
        res.add(Text(
          word + ' ',
          style: style,
        ));
      } else {
        var parts = word.split(emoji);
        int i = 0;
        for (Match m in matches) {
          res.add(RotatedBox(quarterTurns: 1, child: Text(parts[i++])));
          res.add(Text(m.group(0)));
        }
        res.add(RotatedBox(quarterTurns: 1, child: Text(parts[i] + ' ')));
      }
    }
    return res;
  }

  buildPendingItem({Coupon coupon}) {
    return GestureDetector(
      onTap: () {
        if (coupon.status == couponStatusMap[CouponStatus.activated]) {
          if (DateTime.parse(coupon.effDate).isBefore(DateTime.now()))
            Navigator.pushNamed(context, RoutePaths.Trade,
                arguments: RouteParamsOfTrade(isUp: true, isCoupon: true, defaultCoupon: coupon));
        } else if (coupon.custom.humanActivate) {
          Navigator.pushNamed(context, RoutePaths.Feedback);
        }
      },
      child: Container(
          margin: EdgeInsets.only(
              left: ScreenUtil.getInstance().setWidth(15),
              right: ScreenUtil.getInstance().setWidth(15),
              top: ScreenUtil.getInstance().setHeight(15)),
          decoration: BoxDecoration(
              color: Palette.pagePrimaryColor,
              borderRadius: StyleFactory.corner,
              boxShadow: [StyleFactory.shadow]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Image.asset(
                          coupon.status == couponStatusMap[CouponStatus.activated]
                              ? R.resAssetsIconsCouponYellow
                              : (coupon.custom.humanActivate
                                  ? R.resAssetsIconsCouponRed
                                  : R.resAssetsIconsCouponGrey),
                          width: ScreenUtil.getInstance().setWidth(94),
                          height: ScreenUtil.getInstance().setWidth(92),
                        ),
                        Positioned.fill(
                            child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                coupon.amount.toStringAsFixed(0),
                                style: StyleNewFactory.white40,
                              ),
                              Text(
                                "USDT",
                                style: StyleNewFactory.white15,
                              )
                            ],
                          ),
                        ))
                      ],
                    ),
                    SizedBox(width: ScreenUtil.getInstance().setWidth(5)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: ScreenUtil.getInstance().setHeight(10),
                        ),
                        Text(
                          coupon.custom.title,
                          style: StyleNewFactory.black15,
                        ),
                        Text(
                          coupon.custom.description,
                          style: StyleNewFactory.grey12,
                        ),
                        SizedBox(
                          height: ScreenUtil.getInstance().setHeight(5),
                        ),
                        Text("有效期:", style: StyleNewFactory.grey12),
                        Text(
                            coupon.status == couponStatusMap[CouponStatus.activated]
                                ? "${dateFormat(date: coupon.effDate)}-${dateFormat(date: coupon.expDate)}"
                                : "${dateFormat(date: coupon.actEffDate)}-${dateFormat(date: coupon.actExpDate)}",
                            style: StyleNewFactory.grey11),
                        SizedBox(
                          height: ScreenUtil.getInstance().setHeight(5),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Stack(
                children: <Widget>[
                  SvgPicture.asset(R.resAssetsIconsWave,
                      height: ScreenUtil.getInstance().setWidth(92)),
                  Positioned.fill(
                      child: Align(
                          alignment: Alignment.center,
                          child: Wrap(
                            children: coupon.status == couponStatusMap[CouponStatus.activated]
                                ? _getWords(
                                    "立 即 使 用",
                                    DateTime.parse(coupon.effDate).isBefore(DateTime.now())
                                        ? StyleNewFactory.yellowOrange14
                                        : StyleNewFactory.grey14)
                                : (coupon.custom.humanActivate
                                    ? _getWords("待 激 活", StyleNewFactory.yellowOrange14)
                                    : _getWords("未 生 效", StyleNewFactory.grey14)),
                            direction: Axis.vertical,
                          )))
                ],
              )
            ],
          )),
    );
  }

  buildUsedItems({Coupon coupon}) {
    return Container(
        margin: EdgeInsets.only(
            left: ScreenUtil.getInstance().setWidth(15),
            right: ScreenUtil.getInstance().setWidth(15),
            top: ScreenUtil.getInstance().setHeight(15)),
        decoration: BoxDecoration(
            color: Palette.pagePrimaryColor,
            borderRadius: StyleFactory.corner,
            boxShadow: [StyleFactory.shadow]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Image.asset(
                  R.resAssetsIconsCouponGrey,
                  width: ScreenUtil.getInstance().setWidth(94),
                  height: ScreenUtil.getInstance().setWidth(92),
                ),
                Positioned.fill(
                    child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        coupon.amount.toStringAsFixed(0),
                        style: StyleNewFactory.white40,
                      ),
                      Text(
                        "USDT",
                        style: StyleNewFactory.white15,
                      )
                    ],
                  ),
                ))
              ],
            ),
            SizedBox(
              width: ScreenUtil.getInstance().setWidth(10),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(10),
                  ),
                  Stack(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            coupon.custom.title,
                            style: StyleNewFactory.grey15,
                          ),
                          Text(
                            coupon.custom.description,
                            style: StyleNewFactory.grey12,
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(right: ScreenUtil.getInstance().setWidth(10)),
                        child: SvgPicture.asset(
                          coupon.status == couponStatusMap[CouponStatus.activateFailed]
                              ? R.resAssetsIconsExpired
                              : R.resAssetsIconsUsed,
                          width: ScreenUtil.getInstance().setWidth(40),
                          height: ScreenUtil.getInstance().setWidth(40),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(5),
                  ),
                  Text("有效期:", style: StyleNewFactory.grey12),
                  Text(
                      coupon.status == couponStatusMap[CouponStatus.activateFailed]
                          ? "${dateFormat(date: coupon.actEffDate)} - ${dateFormat(date: coupon.actExpDate)}"
                          : "${dateFormat(date: coupon.effDate)} - ${dateFormat(date: coupon.expDate)}",
                      style: StyleNewFactory.grey11),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(5),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

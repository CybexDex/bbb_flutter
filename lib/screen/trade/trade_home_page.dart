import 'package:bbb_flutter/logic/coupon_order_view_model.dart';
import 'package:bbb_flutter/logic/limit_order_vm.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/screen/trade/trade_coupon_page.dart';
import 'package:bbb_flutter/screen/trade/trade_usdt_page.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/decorated_tabbar.dart';
import 'package:flutter_svg/svg.dart';

class TradeHomePage extends StatefulWidget {
  TradeHomePage({Key key}) : super(key: key);

  @override
  _TradeHomePageState createState() {
    return _TradeHomePageState();
  }
}

class _TradeHomePageState extends State<TradeHomePage> {
  @override
  Widget build(BuildContext context) {
    final RouteParamsOfTrade params = ModalRoute.of(context).settings.arguments;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LimitOrderViewModel>(create: (context) {
          var tv = locator.get<LimitOrderViewModel>();
          tv.initForm(params.isUp);
          tv.fetchPostion();
          return tv;
        }),
        ChangeNotifierProvider<CouponOrderViewModel>(
          create: (context) {
            var cv = locator.get<CouponOrderViewModel>();
            cv.initForm(params.isUp, params.defaultCoupon);
            // cv.fetchCouponBalance();
            return cv;
          },
        )
      ],
      child: DefaultTabController(
          length: locator.get<UserManager>().user.loginType == LoginType.test ||
                  locator.get<UserManager>().user.loginType == LoginType.reward
              ? 1
              : 2,
          initialIndex: params.isCoupon ? 1 : 0,
          child: Scaffold(
            appBar: PreferredSize(
                child: AppBar(
                    leading: IconButton(
                        icon: Icon(Icons.arrow_back_ios,
                            color: Palette.backButtonColor,
                            size: ScreenUtil.getInstance().setWidth(24)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                    centerTitle: true,
                    title: Consumer2<LimitOrderViewModel, CouponOrderViewModel>(
                        builder: (context, model, couponViewModel, child) {
                      return Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              model.updateSide();
                              couponViewModel.updateSide();
                            },
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
                            child: model.orderForm.isUp
                                ? SvgPicture.asset(
                                    R.resAssetsIconsIcUpRed,
                                    width: ScreenUtil.getInstance().setWidth(18),
                                    height: ScreenUtil.getInstance().setHeight(18),
                                  )
                                : SvgPicture.asset(
                                    R.resAssetsIconsIcDownGreen,
                                    width: ScreenUtil.getInstance().setWidth(18),
                                    height: ScreenUtil.getInstance().setHeight(18),
                                  ),
                            onTap: () {
                              model.updateSide();
                              couponViewModel.updateSide();
                            },
                          )
                        ],
                        mainAxisSize: MainAxisSize.min,
                      );
                    }),
                    backgroundColor: Colors.white,
                    brightness: Brightness.light,
                    elevation: 0,
                    bottom: PreferredSize(
                        child: DecoratedTabBar(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Palette.appDividerBackgroudGreyColor,
                              ),
                            ),
                          ),
                          tabBar: TabBar(
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorColor: Palette.appYellowOrange,
                            indicatorWeight: 4,
                            unselectedLabelColor: Palette.appGrey,
                            labelStyle: StyleNewFactory.black18,
                            unselectedLabelStyle: StyleNewFactory.grey15,
                            labelColor: Palette.appBlack,
                            tabs: locator.get<UserManager>().user.loginType == LoginType.test ||
                                    locator.get<UserManager>().user.loginType == LoginType.reward
                                ? [
                                    Container(
                                      height: ScreenUtil.getInstance().setHeight(44),
                                      child: Tab(
                                        text: "USDT",
                                      ),
                                    ),
                                  ]
                                : [
                                    Container(
                                      height: ScreenUtil.getInstance().setHeight(44),
                                      child: Tab(
                                        text: "USDT",
                                      ),
                                    ),
                                    Container(
                                      height: ScreenUtil.getInstance().setHeight(44),
                                      child: Tab(
                                        text: "奖励金",
                                      ),
                                    ),
                                  ],
                          ),
                        ),
                        preferredSize: Size.fromHeight(ScreenUtil.getInstance().setHeight(44)))),
                preferredSize: Size.fromHeight(ScreenUtil.getInstance().setHeight(88))),
            body: SafeArea(
              child: TabBarView(
                physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                children: locator.get<UserManager>().user.loginType == LoginType.test ||
                        locator.get<UserManager>().user.loginType == LoginType.reward
                    ? [TradeUSDTPage()]
                    : [TradeUSDTPage(), TradeCouponPage()],
              ),
            ),
          )),
    );
  }
}

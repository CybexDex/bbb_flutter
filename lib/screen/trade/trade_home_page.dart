import 'package:bbb_flutter/logic/coupon_order_view_model.dart';
import 'package:bbb_flutter/logic/limit_order_vm.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/screen/trade/trade_coupon_page.dart';
import 'package:bbb_flutter/screen/trade/trade_usdt_page.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/decorated_tabbar.dart';
import 'package:bbb_flutter/widgets/keyboard_scroll_page.dart';
import 'package:flutter_svg/svg.dart';

class TradeHomePage extends StatefulWidget {
  TradeHomePage({Key key}) : super(key: key);

  @override
  _TradeHomePageState createState() {
    return _TradeHomePageState();
  }
}

class _TradeHomePageState extends State<TradeHomePage> {
  var appBar = AppBar(
    iconTheme: IconThemeData(
      color: Palette.backButtonColor, //change your color here
    ),
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
                model.orderForm.isUp ? "${I18n.of(context).buyUp}" : "${I18n.of(context).buyDown}",
                style: model.orderForm.isUp ? StyleFactory.buyUpTitle : StyleFactory.buyDownTitle),
          ),
          SizedBox(
            width: 7,
          ),
          GestureDetector(
            child: model.orderForm.isUp
                ? SvgPicture.asset(
                    R.resAssetsIconsIcUpRed,
                    width: 18,
                    height: 18,
                  )
                : SvgPicture.asset(
                    R.resAssetsIconsIcDownGreen,
                    width: 18,
                    height: 18,
                  ),
            onTap: model.updateSide,
          )
        ],
        mainAxisSize: MainAxisSize.min,
      );
    }),
    backgroundColor: Colors.white,
    brightness: Brightness.light,
    elevation: 0,
    bottom: PreferredSize(
      preferredSize: Size.fromHeight(48.0),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: DecoratedTabBar(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Palette.appDividerBackgroudGreyColor,
                width: 1.0,
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
            tabs: locator.get<UserManager>().user.loginType == LoginType.test
                ? [
                    Tab(
                      text: "USDT",
                    ),
                  ]
                : [
                    Tab(
                      text: "USDT",
                    ),
                    Tab(text: "代金券"),
                  ],
          ),
        ),
      ),
    ),
  );
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
            cv.initForm(params.isUp);
            cv.fetchCouponBalance();
            cv.onChnageCouponDropdownSelection(params.defaultCoupon);
            return cv;
          },
        )
      ],
      child: DefaultTabController(
          length: locator.get<UserManager>().user.loginType == LoginType.test ? 1 : 2,
          initialIndex: params.isCoupon ? 1 : 0,
          child: Scaffold(
            appBar: appBar,
            body: SafeArea(
              child: TabBarView(
                physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                children: locator.get<UserManager>().user.loginType == LoginType.test
                    ? [TradeUSDTPage()]
                    : [TradeUSDTPage(), TradeCouponPage()],
              ),
            ),
          )),
    );
  }
}

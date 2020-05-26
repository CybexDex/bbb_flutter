import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/screen/account/account_page.dart';
import 'package:bbb_flutter/screen/exchange/exchange.dart';
import 'package:bbb_flutter/screen/exchange/nav_drawer_assets.dart';
import 'package:bbb_flutter/screen/forum/forum_home.dart';
import 'package:bbb_flutter/screen/home/home_page.dart';
import 'package:bbb_flutter/screen/home/home_view_model.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  State createState() => _MainState();
}

class _MainState extends State<MainPage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomePage(),
    ExchangePage(),
    ForumHome(),
    AccountPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: _currentIndex == 1 ? NavDrawer() : null,
        resizeToAvoidBottomPadding: false,
        bottomNavigationBar: BottomNavigationBar(
          key: navGlobaykey,
          backgroundColor: Colors.white,
          selectedItemColor: Palette.bottomNavLabelSelectedColor,
          unselectedItemColor: Palette.bottomNavLabelUnselectedColor,
          selectedLabelStyle: StyleNewFactory.black10,
          unselectedLabelStyle: StyleNewFactory.grey10,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: onTabTapped,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                R.resAssetsIconsIcHomeUnselected,
                width: ScreenUtil.getInstance().setWidth(24),
                height: ScreenUtil.getInstance().setHeight(24),
              ),
              activeIcon: SvgPicture.asset(
                R.resAssetsIconsIcHomeSelected,
                width: ScreenUtil.getInstance().setWidth(24),
                height: ScreenUtil.getInstance().setHeight(24),
              ),
              title: new Text(I18n.of(context).navHome),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                R.resAssetsIconsIcTransactionUnselected,
                width: ScreenUtil.getInstance().setWidth(24),
                height: ScreenUtil.getInstance().setHeight(24),
              ),
              activeIcon: SvgPicture.asset(
                R.resAssetsIconsIcTransactionSelected,
                width: ScreenUtil.getInstance().setWidth(24),
                height: ScreenUtil.getInstance().setHeight(24),
              ),
              title: new Text(I18n.of(context).navTransaction),
            ),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  R.resAssetsIconsIcForumUnselected,
                  width: ScreenUtil.getInstance().setWidth(24),
                  height: ScreenUtil.getInstance().setHeight(24),
                ),
                activeIcon: SvgPicture.asset(
                  R.resAssetsIconsIcForumSelected,
                  width: ScreenUtil.getInstance().setWidth(24),
                  height: ScreenUtil.getInstance().setHeight(24),
                ),
                title: Text(I18n.of(context).navForum)),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  R.resAssetsIconsIcAccountUnselected,
                  width: ScreenUtil.getInstance().setWidth(24),
                  height: ScreenUtil.getInstance().setHeight(24),
                ),
                activeIcon: SvgPicture.asset(
                  R.resAssetsIconsIcAccountSelected,
                  width: ScreenUtil.getInstance().setWidth(24),
                  height: ScreenUtil.getInstance().setHeight(24),
                ),
                title: Text(I18n.of(context).navAccount))
          ],
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: _children,
        ));
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (locator.get<UserManager>().user.logined && index == 3) {
      locator.get<UserManager>().fetchBalances(name: locator.get<UserManager>().user.name);
    }
    if (index == 0) {
      locator.get<HomeViewModel>().getRankingList();
    }
  }
}

import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/screen/account/account_page.dart';
import 'package:bbb_flutter/screen/exchange/exchange.dart';
import 'package:bbb_flutter/screen/forum/forum_home.dart';
import 'package:bbb_flutter/screen/home/home_page.dart';
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
        resizeToAvoidBottomPadding: false,
        bottomNavigationBar: BottomNavigationBar(
          key: navGlobaykey,
          backgroundColor: Colors.white,
          selectedItemColor: Palette.bottomNavLabelSelectedColor,
          unselectedItemColor: Palette.bottomNavLabelUnselectedColor,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: onTabTapped,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                R.resAssetsIconsIcHomeUnselected,
                width: 28,
                height: 28,
              ),
              activeIcon: SvgPicture.asset(
                R.resAssetsIconsIcHomeSelected,
                width: 28,
                height: 28,
              ),
              title: new Text('首页'),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                R.resAssetsIconsIcTransactionUnselected,
                width: 28,
                height: 28,
              ),
              activeIcon: SvgPicture.asset(
                R.resAssetsIconsIcTransactionSelected,
                width: 28,
                height: 28,
              ),
              title: new Text('交易'),
            ),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  R.resAssetsIconsIcForumUnselected,
                  width: 28,
                  height: 28,
                ),
                activeIcon: SvgPicture.asset(
                  R.resAssetsIconsIcForumSelected,
                  width: 28,
                  height: 28,
                ),
                title: Text('社区')),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  R.resAssetsIconsIcAccountUnselected,
                  width: 28,
                  height: 28,
                ),
                activeIcon: SvgPicture.asset(
                  R.resAssetsIconsIcAccountSelected,
                  width: 28,
                  height: 28,
                ),
                title: Text('我的'))
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
      locator
          .get<UserManager>()
          .fetchBalances(name: locator.get<UserManager>().user.name);
    }
  }
}

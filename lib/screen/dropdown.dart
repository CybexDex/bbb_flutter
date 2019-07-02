import 'package:bbb_flutter/logic/trade_vm.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:vertical_tabs/vertical_tabs.dart';

class Dropdown extends StatelessWidget {
  final double menuHeight;
  final TradeViewModel tradeViewModel;

  const Dropdown({Key key, this.menuHeight, this.tradeViewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 120),
      color: Palette.pagePrimaryColor,
      height: menuHeight,
      width: ScreenUtil.screenWidth,
      child: Container(
          child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 20, top: 15, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("类型"),
                Text("强制平仓价格"),
                Text("剩余可买"),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 15),
              child: VerticalTabs(
                indicatorWidth: 0,
                selectedTabBackgroundColor: Palette.dropDownIndicatorColor,
                unselectedTabBackgroundColor: Palette.pagePrimaryColor,
                tabsElevation: 0,
                tabsWidth: 85,
                tabs: <Tab>[
                  Tab(
                    child: Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Row(
                        children: <Widget>[
                          Image.asset(R.resAssetsIconsIcUpRed14),
                          SizedBox(
                            width: 5,
                          ),
                          Text(I18n.of(context).buyUp,
                              style: StyleFactory.buyUpText),
                        ],
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Row(
                        children: <Widget>[
                          Image.asset(R.resAssetsIconsIcDownGreen14),
                          SizedBox(
                            width: 5,
                          ),
                          Text(I18n.of(context).buyDown,
                              style: StyleFactory.buyDownText),
                        ],
                      ),
                    ),
                  )
                ],
                contents: <Widget>[
                  Container(
                    child: ListView.builder(
                        itemCount: tradeViewModel.getUpContracts().length,
                        itemExtent: 50,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.only(left: 30, right: 20),
                            color: Palette.dropDownIndicatorColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(tradeViewModel
                                    .getUpContracts()[index]
                                    .strikeLevel
                                    .toString()),
                                Text(tradeViewModel
                                    .getUpContracts()[index]
                                    .availableInventory
                                    .toString())
                              ],
                            ),
                          );
                        }),
                  ),
                  Container(
                    child: ListView.builder(
                        itemCount: tradeViewModel.getDownContracts().length,
                        itemExtent: 50,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.only(left: 50, right: 20),
                            color: Palette.dropDownIndicatorColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(tradeViewModel
                                    .getDownContracts()[index]
                                    .strikeLevel
                                    .toString()),
                                Text(tradeViewModel
                                    .getDownContracts()[index]
                                    .availableInventory
                                    .toString())
                              ],
                            ),
                          );
                        }),
                  )
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}

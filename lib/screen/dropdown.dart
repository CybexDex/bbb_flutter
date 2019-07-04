import 'package:bbb_flutter/logic/trade_vm.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:vertical_tabs/vertical_tabs.dart';

class Dropdown extends StatelessWidget {
  final double menuHeight;
  final void Function() function;

  const Dropdown({Key key, this.menuHeight, this.function}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 120),
        color: Palette.pagePrimaryColor,
        height: menuHeight,
        width: ScreenUtil.screenWidth,
        child: Consumer<TradeViewModel>(builder: (context, model, child) {
          return Container(
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
                    selectedTabBackgroundColor: Palette.veryLightPink,
                    unselectedTabBackgroundColor:
                        Palette.dropDownIndicatorColor,
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
                            itemCount: model.getUpContracts().length,
                            itemExtent: 50,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  model.updateCurrentContract(true,
                                      model.getUpContracts()[index].contractId);
                                  function();
                                },
                                child: Container(
                                  padding: EdgeInsets.only(left: 30, right: 20),
                                  color: model.contract ==
                                          model.getUpContracts()[index]
                                      ? Palette.veryLightPink
                                      : Palette.dropDownIndicatorColor,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(model
                                          .getUpContracts()[index]
                                          .strikeLevel
                                          .toString()),
                                      Text(model
                                          .getUpContracts()[index]
                                          .availableInventory
                                          .toString())
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                      Container(
                        child: ListView.builder(
                            itemCount: model.getDownContracts().length,
                            itemExtent: 50,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  model.updateCurrentContract(
                                      false,
                                      model
                                          .getDownContracts()[index]
                                          .contractId);
                                  function();
                                },
                                child: Container(
                                  padding: EdgeInsets.only(left: 50, right: 20),
                                  color: model.contract ==
                                          model.getDownContracts()[index]
                                      ? Palette.veryLightPink
                                      : Palette.dropDownIndicatorColor,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(model
                                          .getDownContracts()[index]
                                          .strikeLevel
                                          .toString()),
                                      Text(model
                                          .getDownContracts()[index]
                                          .availableInventory
                                          .toString())
                                    ],
                                  ),
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                ),
              )
            ],
          ));
        }));
  }
}

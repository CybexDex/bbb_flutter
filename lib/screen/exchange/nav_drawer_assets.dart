import 'package:bbb_flutter/logic/nav_drawer_vm.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter/cupertino.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({Key key}) : super(key: key);

  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  @override
  void initState() {
    locator.get<NavDrawerViewModel>().subscribeTicker();
    locator.get<NavDrawerViewModel>().getAssetList();
    super.initState();
  }

  @override
  void dispose() {
    locator.get<NavDrawerViewModel>().unsubscribeTicker();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the Drawer if there isn't enough vertical
        // space to fit everything.
        child: Consumer<NavDrawerViewModel>(
      builder: (context, model, child) {
        return Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 50, left: 15, bottom: 16),
                child: Align(
                  child: Text(
                    I18n.of(context).navDrawerSelectContract,
                    style: StyleNewFactory.black18,
                  ),
                  alignment: Alignment.topLeft,
                ),
              ),
              Expanded(
                child: ListView.builder(
                    padding: EdgeInsets.only(top: 0),
                    itemCount: model.tickerList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          model.onChangeAsset(
                              context: context, asset: model.assetList[index].underlying);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 17),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    RichText(
                                        text: TextSpan(children: [
                                      TextSpan(
                                        text: model.assetList[index].underlying,
                                        style: StyleNewFactory.black15,
                                      ),
                                      TextSpan(
                                        text: "/USDT",
                                        style: StyleNewFactory.grey12,
                                      )
                                    ])),
                                    Text(
                                      model.tickerList[index].latest,
                                      style: double.parse(model.tickerList[index].latest) >
                                              model.tickerList[index].lastDayPx
                                          ? StyleNewFactory.red15
                                          : StyleNewFactory.green15,
                                    )
                                  ],
                                )),
                            Divider(
                              color: Palette.separatorColor,
                            )
                          ],
                        ),
                      );
                    }),
              )
            ],
          ),
        );
      },
    ));
  }
}

import 'dart:collection';

import 'package:bbb_flutter/helper/ui_utils.dart';
import 'package:bbb_flutter/models/response/fund_record_model.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/decorated_tabbar.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/widgets/empty_records.dart';
import 'package:bbb_flutter/widgets/fund_record_item.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class FundRecordsWidget extends StatefulWidget {
  const FundRecordsWidget({Key key}) : super(key: key);

  @override
  _FundRecordsWidgetState createState() => _FundRecordsWidgetState();
}

class _FundRecordsWidgetState extends State<FundRecordsWidget> {
  List<FundRecordModel> data = [];
  List<FundRecordModel> depositData = [];
  List<FundRecordModel> withdrawalData = [];
  LinkedHashMap<int, List<FundRecordModel>> dataMap = LinkedHashMap();
  LinkedHashMap<int, List<FundRecordModel>> depositMap = LinkedHashMap();
  LinkedHashMap<int, List<FundRecordModel>> withdrawalMap = LinkedHashMap();

  @override
  void initState() {
    final name = locator.get<UserManager>().user.name;
    locator
        .get<BBBAPI>()
        .getFundRecords(
            name: name,
            start: DateTime.now().toUtc().subtract(Duration(days: 30)),
            end: DateTime.now().toUtc())
        .then((d) {
      data = d
          .where((f) =>
              fundTypeMap[f.type] == FundType.userDepositExtern ||
              fundTypeMap[f.type] == FundType.userWithdrawExtern)
          .toList();
      depositData = d
          .where((f) => fundTypeMap[f.type] == FundType.userDepositExtern)
          .toList();
      withdrawalData = d
          .where((f) => fundTypeMap[f.type] == FundType.userWithdrawExtern)
          .toList();
      _constructMap(data, dataMap);
      _constructMap(depositData, depositMap);
      _constructMap(withdrawalData, withdrawalMap);
      setState(() {});
    });

    super.initState();
  }

  _constructMap(List<FundRecordModel> list, var map) {
    int count = 0;
    for (int i = 0; i < list.length; i++) {
      if (list.length == 1) {
        var month = list[i].lastUpdateTime.toLocal().month;
        map.putIfAbsent(month, () => list);
        break;
      }
      if (i == 0) continue;
      var current = list[i].lastUpdateTime.toLocal().month;
      var prev = list[i - 1].lastUpdateTime.toLocal().month;
      if (current != prev) {
        map.putIfAbsent(prev, () => list.sublist(count, i));
        count = i;
      } else if (i == list.length - 1) {
        map.putIfAbsent(current, () => list.sublist(count));
      }
    }
  }

  List<Widget> _buildSlivers(var map) {
    List<Widget> slivers = [];
    map.forEach((key, value) {
      slivers.addAll(
        List.generate(1, (sliverIndex) {
          return SliverStickyHeader(
            header: headerBuild(key),
            sliver: SliverList(
              delegate: new SliverChildBuilderDelegate(
                (context, i) => Column(
                  children: <Widget>[
                    FundRecordItem(
                      model: value[i],
                    ),
                    Divider(
                      height: 1,
                      color: Palette.separatorColor,
                    ),
                  ],
                ),
                childCount: value.length,
              ),
            ),
          );
        }),
      );
    });
    return slivers;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Palette.backButtonColor, //change your color here
          ),
          centerTitle: true,
          title: Text(I18n.of(context).cashRecords, style: StyleFactory.title),
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
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(
                        color: Palette.invitePromotionBadgeColor, width: 4),
                    insets: EdgeInsets.fromLTRB(0, 0.0, 60, 0),
                  ),
                  unselectedLabelColor: Palette.appGrey,
                  labelStyle: StyleNewFactory.black18,
                  unselectedLabelStyle: StyleNewFactory.grey15,
                  labelColor: Palette.appBlack,
                  labelPadding: EdgeInsets.only(right: 60),
                  tabs: [
                    Tab(
                      text: I18n.of(context).all,
                    ),
                    Tab(text: I18n.of(context).topUp),
                    Tab(
                      text: I18n.of(context).withdraw,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            children: [
              Container(
                  child: data.length == 0
                      ? EmptyRecords()
                      : CustomScrollView(
                          slivers: _buildSlivers(dataMap),
                        )
                  // : ListView.separated(
                  //     separatorBuilder: (context, index) => Divider(
                  //       height: 1,
                  //       color: Palette.separatorColor,
                  //     ),
                  //     itemCount: data.length,
                  //     itemBuilder: (context, index) {
                  //       return FundRecordItem(
                  //         model: data[index],
                  //       );
                  //     },
                  //   ),
                  ),
              Container(
                  child: depositData.length == 0
                      ? EmptyRecords()
                      : CustomScrollView(
                          slivers: _buildSlivers(depositMap),
                        )
                  // : ListView.separated(
                  //     separatorBuilder: (context, index) => Divider(
                  //       height: 1,
                  //       color: Palette.separatorColor,
                  //     ),
                  //     itemCount: depositData.length,
                  //     itemBuilder: (context, index) {
                  //       return FundRecordItem(
                  //         model: depositData[index],
                  //       );
                  //     },
                  //   ),
                  ),
              Container(
                  child: withdrawalData.length == 0
                      ? EmptyRecords()
                      : CustomScrollView(
                          slivers: _buildSlivers(withdrawalMap),
                        )
                  // : ListView.separated(
                  //     separatorBuilder: (context, index) => Divider(
                  //       height: 1,
                  //       color: Palette.separatorColor,
                  //     ),
                  //     itemCount: withdrawalData.length,
                  //     itemBuilder: (context, index) {
                  //       return FundRecordItem(
                  //         model: withdrawalData[index],
                  //       );
                  //     },
                  //   ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

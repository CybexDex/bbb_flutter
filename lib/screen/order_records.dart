import 'dart:collection';

import 'package:bbb_flutter/helper/ui_utils.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/order_response_model.dart';
import 'package:bbb_flutter/routes/routes.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/decorated_tabbar.dart';
import 'package:bbb_flutter/widgets/empty_records.dart';
import 'package:bbb_flutter/widgets/order_record_item.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class OrderRecordsWidget extends StatefulWidget {
  const OrderRecordsWidget({Key key}) : super(key: key);

  @override
  _OrderRecordsWidgetState createState() => _OrderRecordsWidgetState();
}

class _OrderRecordsWidgetState extends State<OrderRecordsWidget> {
  List<OrderResponseModel> data = [];
  List<OrderResponseModel> upData = [];
  List<OrderResponseModel> downData = [];
  LinkedHashMap<int, List<OrderResponseModel>> orderMap = LinkedHashMap();
  LinkedHashMap<int, List<OrderResponseModel>> upOrderMap = LinkedHashMap();
  LinkedHashMap<int, List<OrderResponseModel>> downOrderMap = LinkedHashMap();

  @override
  void initState() {
    final name = locator.get<UserManager>().user.name;
    locator
        .get<BBBAPI>()
        .getOrders(name,
            status: [OrderStatus.closed],
            startTime: (DateTime.now().subtract(Duration(days: 90)))
                .toUtc()
                .toIso8601String(),
            endTime: DateTime.now().toUtc().toIso8601String())
        .then((d) {
      data = d;
      upData = d.where((o) => o.contractId.contains("N")).toList();
      downData = d.where((o) => !o.contractId.contains("N")).toList();
      _constructMap(data, orderMap);
      _constructMap(upData, upOrderMap);
      _constructMap(downData, downOrderMap);
      setState(() {});
    });

    super.initState();
  }

  _constructMap(List<OrderResponseModel> list, var map) {
    int count = 0;
    for (int i = 0; i < list.length; i++) {
      if (list.length == 1) {
        var month = DateTime.parse(list[i].settleTime).toLocal().month;
        map.putIfAbsent(month, () => list);
        break;
      }
      if (i == 0) continue;
      var current = DateTime.parse(list[i].settleTime).toLocal().month;
      var prev = DateTime.parse(list[i - 1].settleTime).toLocal().month;
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
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context, RoutePaths.OrderRecordDetail,
                            arguments: RouteParamsOfTransactionRecords(
                                orderResponseModel: value[i]));
                      },
                      child: OrderRecordItem(
                        model: value[i],
                      ),
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
          title: Text(I18n.of(context).transactionRecords,
              style: StyleFactory.title),
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
                    Tab(text: I18n.of(context).buyUp),
                    Tab(
                      text: I18n.of(context).buyDown,
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
                          slivers: _buildSlivers(orderMap),
                        )),
              Container(
                  child: upData.length == 0
                      ? EmptyRecords()
                      : CustomScrollView(
                          slivers: _buildSlivers(upOrderMap),
                        )),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 20),
              //   child: upData.length == 0
              //       ? EmptyRecords()
              //       : ListView.separated(
              //           separatorBuilder: (context, index) => Divider(
              //             height: 1,
              //             color: Palette.separatorColor,
              //           ),
              //           itemCount: upData.length,
              //           itemBuilder: (context, index) {
              //             return InkWell(
              //               onTap: () {
              //                 Navigator.pushNamed(
              //                     context, RoutePaths.OrderRecordDetail,
              //                     arguments: RouteParamsOfTransactionRecords(
              //                         orderResponseModel: upData[index]));
              //               },
              //               child: OrderRecordItem(
              //                 model: upData[index],
              //               ),
              //             );
              //           },
              //         ),
              // ),
              Container(
                  child: downData.length == 0
                      ? EmptyRecords()
                      : CustomScrollView(
                          slivers: _buildSlivers(downOrderMap),
                        )),
            ],
          ),
        ),
      ),
    );
  }
}

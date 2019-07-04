import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/order_response_model.dart';
import 'package:bbb_flutter/routes/routes.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/decorated_tabbar.dart';
import 'package:bbb_flutter/widgets/order_record_item.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api_provider.dart';

class OrderRecordsWidget extends StatefulWidget {
  const OrderRecordsWidget({Key key}) : super(key: key);

  @override
  _OrderRecordsWidgetState createState() => _OrderRecordsWidgetState();
}

class _OrderRecordsWidgetState extends State<OrderRecordsWidget> {
  List<OrderResponseModel> data = [];
  List<OrderResponseModel> upData = [];
  List<OrderResponseModel> downData = [];

  @override
  void initState() {
    final name = locator.get<UserManager>().user.name;
    locator
        .get<BBBAPIProvider>()
        .getOrders(name, status: [OrderStatus.closed]).then((d) {
      setState(() {
        data = d;
        upData = d.where((o) => o.contractId.contains("N")).toList();
        downData = d.where((o) => !o.contractId.contains("N")).toList();
      });
    });

    super.initState();
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
          bottom: DecoratedTabBar(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Palette.separatorColor,
                  width: 1.0,
                ),
              ),
            ),
            tabBar: TabBar(
              indicatorWeight: 1,
              indicatorColor: Palette.redOrange,
              unselectedLabelColor: Palette.subTitleColor,
              labelColor: Palette.redOrange,
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
        body: SafeArea(
          child: TabBarView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: Palette.separatorColor,
                  ),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                   return InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context, RoutePaths.OrderRecordDetail);
                      },
                      child: OrderRecordItem(
                        model: data[index],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: Palette.separatorColor,
                  ),
                  itemCount: upData.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context, RoutePaths.OrderRecordDetail);
                      },
                      child: OrderRecordItem(
                        model: upData[index],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: Palette.separatorColor,
                  ),
                  itemCount: downData.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context, RoutePaths.OrderRecordDetail);
                      },
                      child: OrderRecordItem(
                        model: downData[index],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:bbb_flutter/models/response/fund_record_model.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/decorated_tabbar.dart';
import 'package:bbb_flutter/services/network/bbb/bbb_api_provider.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/widgets/fund_record_item.dart';

class FundRecordsWidget extends StatefulWidget {
  const FundRecordsWidget({Key key}) : super(key: key);

  @override
  _FundRecordsWidgetState createState() => _FundRecordsWidgetState();
}

class _FundRecordsWidgetState extends State<FundRecordsWidget> {
  List<FundRecordModel> data = [];
  List<FundRecordModel> depositData = [];
  List<FundRecordModel> withdrawalData = [];

  @override
  void initState() {
    final name = locator.get<UserManager>().user.name;
    locator
        .get<BBBAPIProvider>()
        .getFundRecords(
            name: name,
            start: DateTime.now().toUtc().subtract(Duration(days: 30)),
            end: DateTime.now().toUtc())
        .then((d) {
      setState(() {
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
          title: Text(I18n.of(context).cashRecords, style: StyleFactory.title),
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
                Tab(text: I18n.of(context).topUp),
                Tab(
                  text: I18n.of(context).withdraw,
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
                    return FundRecordItem(
                      model: data[index],
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
                  itemCount: depositData.length,
                  itemBuilder: (context, index) {
                    return FundRecordItem(
                      model: depositData[index],
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
                  itemCount: withdrawalData.length,
                  itemBuilder: (context, index) {
                    return FundRecordItem(
                      model: withdrawalData[index],
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

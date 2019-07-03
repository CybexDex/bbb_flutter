import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/decorated_tabbar.dart';

class FundRecordsWidget extends StatelessWidget {
  const FundRecordsWidget({Key key}) : super(key: key);

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
                  separatorBuilder: (context, index) => index != 0
                      ? Divider(
                          color: Palette.separatorColor,
                        )
                      : Container(),
                  itemCount: 100,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 76,
                      child: Text("$index"),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ListView.separated(
                  separatorBuilder: (context, index) => index != 0
                      ? Divider(
                          color: Palette.separatorColor,
                        )
                      : Container(),
                  itemCount: 100,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 76,
                      child: Text("$index"),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ListView.separated(
                  separatorBuilder: (context, index) => index != 0
                      ? Divider(
                          color: Palette.separatorColor,
                        )
                      : Container(),
                  itemCount: 100,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 76,
                      child: Text("$index"),
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

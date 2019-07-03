import 'package:bbb_flutter/shared/ui_common.dart';

class OrderRecordsWidget extends StatelessWidget {
  const OrderRecordsWidget({Key key}) : super(key: key);

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
          bottom: TabBar(
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
        body: SafeArea(
          child: TabBarView(
            children: [
              Icon(Icons.directions_car),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:bbb_flutter/screen/allLimitOrders/all_limit_orders.dart';
import 'package:bbb_flutter/screen/allOrders/all_orders.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter/widgets.dart';

class OrderHome extends StatefulWidget {
  const OrderHome({Key key}) : super(key: key);

  @override
  _OrderWidget createState() => _OrderWidget();
}

class _OrderWidget extends State<OrderHome> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Palette.backButtonColor, //change your color here
          ),
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          elevation: 0,
          title: TabBar(
            isScrollable: true,
            labelStyle: StyleFactory.title,
            unselectedLabelStyle: StyleFactory.larSubtitle,
            indicator: ShapeDecoration(
                shape: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(
                        width: 8, color: Palette.invitePromotionBadgeColor))),
            unselectedLabelColor: Palette.descColor,
            labelColor: Palette.subTitleColor,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(
                text: I18n.of(context).holdAll,
              ),
              Tab(text: I18n.of(context).limitOpenAll),
            ],
            onTap: (index) {},
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: <Widget>[
              AllOrdersPage(),
              AllLimitOrderPage(),
            ],
          ),
        ),
      ),
    );
  }
}

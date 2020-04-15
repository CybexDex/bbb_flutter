import 'package:bbb_flutter/screen/forum/astrology_page.dart';
import 'package:bbb_flutter/screen/forum/news_page.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter/widgets.dart';

class ForumHome extends StatefulWidget {
  const ForumHome({Key key}) : super(key: key);

  @override
  _ForumWidget createState() => _ForumWidget();
}

class _ForumWidget extends State<ForumHome> {
  GlobalKey _key = GlobalKey();
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
                    borderSide: BorderSide(width: 8, color: Palette.invitePromotionBadgeColor))),
            unselectedLabelColor: Palette.descColor,
            labelColor: Palette.subTitleColor,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(
                text: I18n.of(context).astrology,
              ),
              // Tab(text: I18n.of(context).blockchainVip),
              Tab(text: I18n.of(context).news),
            ],
            onTap: (index) {},
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: <Widget>[
              AstrologyPage(),
              // new BlockchainVipPage(),
              NewsPage(
                key: _key,
              )
            ],
          ),
        ),
      ),
    );
  }
}

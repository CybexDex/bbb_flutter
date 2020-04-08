import 'package:bbb_flutter/helper/ui_utils.dart';
import 'package:bbb_flutter/logic/transfer_records_vm.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/decorated_tabbar.dart';
import 'package:bbb_flutter/widgets/empty_records.dart';
import 'package:bbb_flutter/widgets/transfer_records_item.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class TransferRecordsWidget extends StatefulWidget {
  const TransferRecordsWidget({Key key}) : super(key: key);

  @override
  _TransferRecordsState createState() => _TransferRecordsState();
}

class _TransferRecordsState extends State<TransferRecordsWidget> {
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
                      child: TransferRecordsItem(
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
        child: BaseWidget<TransferRecordsViewModel>(
          model: TransferRecordsViewModel(locator.get(), locator.get()),
          onModelReady: (model) {
            model.getRecords();
          },
          builder: (context, model, child) {
            return Scaffold(
              appBar: AppBar(
                iconTheme: IconThemeData(
                  color: Palette.backButtonColor, //change your color here
                ),
                centerTitle: true,
                title: Text(I18n.of(context).transferRecords, style: StyleFactory.title),
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
                          borderSide:
                              BorderSide(color: Palette.invitePromotionBadgeColor, width: 4),
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
                          Tab(text: I18n.of(context).transferIn),
                          Tab(
                            text: I18n.of(context).transferOut,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              body: SafeArea(
                child: TabBarView(
                  physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  children: [
                    Container(
                        child: model.data.length == 0
                            ? EmptyRecords()
                            : CustomScrollView(
                                slivers: _buildSlivers(model.dataMap),
                              )),
                    Container(
                        child: model.transferIn.length == 0
                            ? EmptyRecords()
                            : CustomScrollView(
                                slivers: _buildSlivers(model.transferInMap),
                              )),
                    Container(
                        child: model.transferOut.length == 0
                            ? EmptyRecords()
                            : CustomScrollView(
                                slivers: _buildSlivers(model.transferOutMap),
                              )),
                  ],
                ),
              ),
            );
          },
        ));
  }
}

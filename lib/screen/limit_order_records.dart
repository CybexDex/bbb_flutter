import 'package:bbb_flutter/helper/ui_utils.dart';
import 'package:bbb_flutter/logic/limit_order_records_vm.dart';
import 'package:bbb_flutter/models/response/bbb_query_response/underlying_asset_response.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/decorated_tabbar.dart';
import 'package:bbb_flutter/widgets/empty_records.dart';
import 'package:bbb_flutter/widgets/limit_order_record_item.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:bbb_flutter/widgets/custom_dropdown.dart' as custom;

class LimitOrderRecordsPage extends StatefulWidget {
  const LimitOrderRecordsPage({Key key}) : super(key: key);

  @override
  _LimitOrderRecordsState createState() => _LimitOrderRecordsState();
}

class _LimitOrderRecordsState extends State<LimitOrderRecordsPage> {
  @override
  void initState() {
    super.initState();
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
                      onTap: () {},
                      child: LimitOrderRecordItem(
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
        child: BaseWidget<LimitOrderRecordsViewModel>(
          model: LimitOrderRecordsViewModel(locator.get(), locator.get()),
          onModelReady: (model) {
            model.getAsset();
            model.getRecords();
          },
          builder: (context, model, child) {
            return Scaffold(
              appBar: AppBar(
                actions: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Palette.separatorColor, width: 0.5),
                    ),
                    width: 100,
                    child: custom.DropdownButton<UnderlyingAssetResponse>(
                      hint: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "选择币种",
                            style: StyleFactory.addReduceStyle,
                          )),
                      height: 100,
                      underline: Container(),
                      value: model.selectedItem,
                      isExpanded: true,
                      items: model.dropdownList,
                      onChanged: model.changeSelectedItem,
                    ),
                  )
                ],
                iconTheme: IconThemeData(
                  color: Palette.backButtonColor, //change your color here
                ),
                centerTitle: true,
                title: Text(I18n.of(context).limitOrderRecords, style: StyleFactory.title),
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
                  physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  children: [
                    Container(
                        child: model.data.length == 0
                            ? EmptyRecords()
                            : CustomScrollView(
                                slivers: _buildSlivers(model.orderMap),
                              )),
                    Container(
                        child: model.upData.length == 0
                            ? EmptyRecords()
                            : CustomScrollView(
                                slivers: _buildSlivers(model.upOrderMap),
                              )),
                    Container(
                        child: model.downData.length == 0
                            ? EmptyRecords()
                            : CustomScrollView(
                                slivers: _buildSlivers(model.downOrderMap),
                              )),
                  ],
                ),
              ),
            );
          },
        ));
  }
}

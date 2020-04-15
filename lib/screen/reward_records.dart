import 'package:bbb_flutter/helper/ui_utils.dart';
import 'package:bbb_flutter/logic/reward_records_vm.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/empty_records.dart';
import 'package:bbb_flutter/widgets/reward_record_item.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:bbb_flutter/widgets/custom_dropdown.dart' as custom;

class RewardRecordsWidget extends StatefulWidget {
  const RewardRecordsWidget({Key key}) : super(key: key);

  @override
  _RewardRecordsState createState() => _RewardRecordsState();
}

class _RewardRecordsState extends State<RewardRecordsWidget> {
  List<Widget> _buildSlivers(var map, RewardRecordsViewModel model) {
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
                      child: RewardRecordItem(
                        model: value[i],
                        vm: model,
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Palette.separatorColor,
                      indent: 15,
                      endIndent: 15,
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
    return BaseWidget<RewardRecordsViewModel>(
      model: RewardRecordsViewModel(locator.get(), locator.get()),
      onModelReady: (model) async {
        await model.getDescription();
        model.getRecords(dropdownType: model.typeList[0]);
        model.buildDropdownMenu();
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              iconTheme: IconThemeData(
                color: Palette.backButtonColor, //change your color here
              ),
              centerTitle: true,
              title: Text(I18n.of(context).rewardRecords, style: StyleFactory.title),
              backgroundColor: Colors.white,
              brightness: Brightness.light,
              elevation: 0,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(48),
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Palette.appDividerBackgroudGreyColor,
                      height: 6,
                    ),
                    Container(
                      color: Colors.white,
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Palette.separatorColor, width: 0.5),
                            borderRadius: BorderRadius.circular(3)),
                        width: 123,
                        height: 35,
                        child: custom.DropdownButton<String>(
                          hint: Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "选择类型",
                                style: StyleFactory.addReduceStyle,
                              )),
                          height: 200,
                          underline: Container(),
                          value: model.selectedItem,
                          isExpanded: true,
                          items: model.dropdownList,
                          onChanged: model.changeSelectedItem,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          body: SafeArea(
              child: Container(
                  child: model.data.length == 0
                      ? EmptyRecords()
                      : CustomScrollView(
                          slivers: _buildSlivers(model.dataMap, model),
                        ))),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

typedef HeaderWidgetBuild = Widget Function(BuildContext context, int position);

typedef ItemWidgetBuild = Widget Function(BuildContext context, int position);

class ListPage extends StatefulWidget {
  final List headerList;
  final List listData;
  final ItemWidgetBuild itemWidgetCreator;
  final HeaderWidgetBuild headerCreator;
  final ScrollController scrollController;
  final RefreshController refreshController;
  final VoidCallback onRefresh;
  final VoidCallback onLoading;

  ListPage(this.listData, this.refreshController,
      {Key key,
      this.headerList,
      this.itemWidgetCreator,
      this.headerCreator,
      this.scrollController,
      this.onLoading,
      this.onRefresh})
      : super(key: key);

  @override
  ListPageState createState() {
    return new ListPageState();
  }
}

class ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        controller: widget.refreshController,
        enablePullDown: true,
        enablePullUp: widget.listData.length >= 10,
        header: WaterDropHeader(),
        footer: ClassicFooter(loadStyle: LoadStyle.ShowWhenLoading),
        onRefresh: widget.onRefresh,
        onLoading: widget.onLoading,
        child: ListView.builder(
            controller: widget.scrollController,
            itemBuilder: (BuildContext context, int position) {
              return buildItemWidget(context, position);
            },
            itemCount: _getListCount()));
  }

  int _getListCount() {
    int itemCount = widget.listData.length;
    return getHeaderCount() + itemCount;
  }

  int getHeaderCount() {
    int headerCount = widget.headerList != null ? widget.headerList.length : 0;
    return headerCount;
  }

  Widget _headerItemWidget(BuildContext context, int index) {
    if (widget.headerCreator != null) {
      return widget.headerCreator(context, index);
    } else {
      return new GestureDetector(
        child: new Padding(
            padding: new EdgeInsets.all(10.0),
            child: new Text("Header Row $index")),
        onTap: () {
          print('header click $index --------------------');
        },
      );
    }
  }

  Widget buildItemWidget(BuildContext context, int index) {
    if (index < getHeaderCount()) {
      return _headerItemWidget(context, index);
    } else {
      int pos = index - getHeaderCount();
      return _itemBuildWidget(context, pos);
    }
  }

  Widget _itemBuildWidget(BuildContext context, int index) {
    if (widget.itemWidgetCreator != null) {
      return widget.itemWidgetCreator(context, index);
    } else {
      return new GestureDetector(
        child: new Padding(
            padding: new EdgeInsets.all(10.0), child: new Text("Row $index")),
        onTap: () {
          print('click $index --------------------');
        },
      );
    }
  }
}

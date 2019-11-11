import 'package:bbb_flutter/models/response/forum_response/news_result.dart';
import 'package:bbb_flutter/services/network/forumApi/forum_api.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/dash_painter.dart';
import 'package:bbb_flutter/widgets/list_page_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:intl/intl.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key key}) : super(key: key);

  @override
  _NewsWidget createState() => _NewsWidget();
}

class _NewsWidget extends State<NewsPage>
    with AutomaticKeepAliveClientMixin<NewsPage> {
  RefreshController _refreshController = new RefreshController();
  List<NewsResult> newsList = [];
  int page = 0;
  void _onRefresh() async {
    page = 0;
    await _loadList(isRefresh: true, pg: page, siz: 10);
    _refreshController.refreshCompleted();
    _refreshController.resetNoData();
  }

  void _onLoading() async {
    page++;
    await _loadList(isRefresh: false, pg: page, siz: 10);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // _testNewsData();
    _loadList(isRefresh: true, pg: 0, siz: 10);
  }

  _loadList({bool isRefresh, int pg, int siz}) async {
    locator.get<ForumApi>().getNews(pg: pg, siz: siz).then((value) {
      if (mounted) {
        setState(() {
          if (isRefresh) {
            newsList.clear();
            newsList.addAll(value.result);
          } else {
            newsList.addAll(value.result);
            if (value.result.length < siz) {
              page--;
              _refreshController.loadNoData();
            } else {
              _refreshController.loadComplete();
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListPage(
      newsList,
      _refreshController,
      onLoading: _onLoading,
      onRefresh: _onRefresh,
      itemWidgetCreator: _getItemWidget,
    );
  }

  _onItemClick(int pos) {
    if (newsList != null && newsList.length > pos) {
      setState(() {
        newsList[pos].showAllText = !newsList[pos].showAllText;
        newsList[pos].showEllipse = !newsList[pos].showEllipse;
      });
    }
  }

  Widget _getItemWidget(BuildContext context, int pos) {
    return new GestureDetector(
      onTap: () {
        _onItemClick(pos);
      },
      child: Stack(children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 16, left: 35, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      newsList[pos].title,
                      style: StyleFactory.forumTitleFontStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 9),
                      child: Text(newsList[pos].content,
                          maxLines: newsList[pos].showAllText ? null : 4,
                          overflow: newsList[pos].showEllipse
                              ? TextOverflow.ellipsis
                              : null,
                          style: StyleFactory.forumContentFontStyle),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(child: getItemBottomWidget(pos))
                  ],
                ),
              )
            ],
          ),
        ),
        Positioned.fill(
          child: Padding(
              padding: EdgeInsets.only(left: 12),
              child: CustomPaint(
                painter: LineDashedPainter(),
              )),
        ),
        Container(
          margin: EdgeInsets.only(top: 20, left: 7),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
              color: Color(0xffa5a5a6),
              borderRadius: BorderRadius.circular(25)),
        ),
      ]),
    );
  }

  Widget getItemBottomWidget(int pos) {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
              child: Text(
                  "${I18n.of(context).forumSource}${newsList[pos].from}",
                  style: StyleFactory.forumItemLabelFontStyle)),
          new Text(
              DateFormat("yyyy-MM-dd hh:mm").format(
                  DateTime.fromMillisecondsSinceEpoch(
                      newsList[pos].created * 1000)),
              style: StyleFactory.forumItemLabelFontStyle)
        ],
      ),
    );
  }
}

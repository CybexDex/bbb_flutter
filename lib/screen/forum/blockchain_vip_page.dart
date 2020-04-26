import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/models/response/forum_response/bolockchain_vip_result.dart';
import 'package:bbb_flutter/services/network/forumApi/forum_api.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/list_page_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:intl/intl.dart';

class BlockchainVipPage extends StatefulWidget {
  const BlockchainVipPage({Key key}) : super(key: key);

  @override
  _BlockchainVipWidget createState() => _BlockchainVipWidget();
}

class _BlockchainVipWidget extends State<BlockchainVipPage>
    with AutomaticKeepAliveClientMixin<BlockchainVipPage> {
  RefreshController _refreshController = new RefreshController();
  List<BlockchainVip> newsList = [];
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
    _loadList(isRefresh: true, pg: 0, siz: 10);
  }

  _loadList({bool isRefresh, int pg, int siz}) async {
    locator.get<ForumApi>().getBlockchainVip(pg: pg, siz: siz).then((value) {
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
      launchURL(url: Uri.encodeFull(newsList[pos].link));
    }
  }

  Widget _getItemWidget(BuildContext context, int pos) {
    return new GestureDetector(
      onTap: () {
        _onItemClick(pos);
      },
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(
                ScreenUtil.getInstance().setWidth(15),
                ScreenUtil.getInstance().setHeight(9),
                ScreenUtil.getInstance().setWidth(15),
                ScreenUtil.getInstance().setHeight(9)),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(newsList[pos].title, style: StyleFactory.forumTitleFontStyle),
                      SizedBox(
                        height: ScreenUtil.getInstance().setHeight(8),
                      ),
                      Text(newsList[pos].preview,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: StyleFactory.forumContentFontStyle),
                      Container(
                          margin: EdgeInsets.only(
                              top: ScreenUtil.getInstance().setHeight(9),
                              right: ScreenUtil.getInstance().setWidth(12)),
                          child: getItemBottomWidget(pos)),
                    ],
                  ),
                ),
                Container(
                    width: ScreenUtil.getInstance().setWidth(100),
                    height: ScreenUtil.getInstance().setHeight(80),
                    child: Image.network(newsList[pos].image)),
              ],
            ),
          ),
          Divider(
            color: Color(0xffe0e0e0),
            indent: ScreenUtil.getInstance().setWidth(15),
            endIndent: ScreenUtil.getInstance().setWidth(15),
          )
        ],
      ),
    );
  }

  Widget getItemBottomWidget(int pos) {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
              child: Text("${I18n.of(context).forumAuthor}${newsList[pos].author}",
                  style: StyleFactory.forumItemLabelFontStyle)),
          new Text(
              DateFormat("yyyy-MM-dd")
                  .format(DateTime.fromMillisecondsSinceEpoch(newsList[pos].updated * 1000)),
              style: StyleFactory.forumItemLabelFontStyle)
        ],
      ),
    );
  }
}

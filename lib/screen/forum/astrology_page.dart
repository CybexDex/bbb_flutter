import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/models/response/forum_response/astrology_result.dart';
import 'package:bbb_flutter/screen/forum/astrology_header_result.dart';
import 'package:bbb_flutter/services/network/forumApi/forum_api.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:bbb_flutter/widgets/list_page_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AstrologyPage extends StatefulWidget {
  const AstrologyPage({Key key}) : super(key: key);

  @override
  _AstrologyWidget createState() => _AstrologyWidget();
}

class _AstrologyWidget extends State<AstrologyPage>
    with AutomaticKeepAliveClientMixin<AstrologyPage> {
  RefreshController _refreshController = new RefreshController();
  List<AstrologyResult> newsList = [];
  AstrologyHeaderResult astrologyHeaderResult;
  int page = 0;

  void _onRefresh() async {
    page = 0;
    await _loadHeader();
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

  _loadHeader() async {
    locator.get<ForumApi>().getAstrologyHeader().then((value) {
      if (mounted) {
        setState(() {
          astrologyHeaderResult = value;
        });
      }
    });
  }

  _loadList({bool isRefresh, int pg, int siz}) async {
    locator.get<ForumApi>().getAstrologyList(pg: pg, siz: siz).then((value) {
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
  void initState() {
    super.initState();
    _loadHeader();
    _loadList(isRefresh: true, pg: 0, siz: 10);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListPage(
      newsList,
      _refreshController,
      onLoading: _onLoading,
      onRefresh: _onRefresh,
      headerList: [1],
      itemWidgetCreator: _getItemWidget,
      headerCreator: (context, position) {
        if (position == 0) {
          return _header();
        } else {
          return new Padding(
            padding: EdgeInsets.all(10.0),
            child: Text('$position -----header------- '),
          );
        }
      },
    );
  }

  Widget _header() {
    return Container(
        decoration: BoxDecoration(
            color: Palette.pagePrimaryColor,
            borderRadius: StyleFactory.corner,
            boxShadow: [StyleFactory.shadow]),
        margin: EdgeInsets.only(left: 15, right: 15, top: 10),
        width: ScreenUtil.screenWidth,
        child: astrologyHeaderResult == null
            ? Container()
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Image.network(astrologyHeaderResult.result.headerImage),
                      Padding(
                        padding: const EdgeInsets.only(left: 28, top: 28),
                        child: Text("今日星运",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              letterSpacing: 0,
                            )),
                      ),
                      Container(
                        alignment: Alignment.topRight,
                        margin: EdgeInsets.only(top: 33, right: 36),
                        child: Column(
                          children: <Widget>[
                            Text(DateTime.now().day.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      ScreenUtil.getInstance().setSp(50.0),
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                )),
                            new Text(
                                "${DateTime.now().year}年${DateTime.now().month}月",
                                style: TextStyle(
                                  fontFamily: 'FZLTZCHK-GBK1-0',
                                  color: Colors.white,
                                  fontSize: Dimen.forumTitleFontSize,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  letterSpacing: 0,
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                      padding: EdgeInsets.fromLTRB(17, 20, 17, 6),
                      child: Text(
                        astrologyHeaderResult.result.content,
                        style: StyleFactory.forumTitleFontStyle,
                      ))
                ],
              ));
  }

  Widget _getItemWidget(BuildContext context, int pos) {
    return new GestureDetector(
      onTap: () {
        _onItemClick(pos);
      },
      child: Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 10),
        padding: EdgeInsets.fromLTRB(15, 9, 15, 8),
        decoration: BoxDecoration(
            color: Palette.pagePrimaryColor,
            borderRadius: StyleFactory.corner,
            boxShadow: [StyleFactory.shadow]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(newsList[pos].title,
                      style: StyleFactory.forumTitleFontStyle),
                  Text(newsList[pos].subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: StyleFactory.forumContentFontStyle),
                  Container(
                      margin: EdgeInsets.only(top: 5),
                      child: getItemBottomWidget(pos)),
                ],
              ),
            ),
            Container(
                height: 60,
                width: 100,
                child: Image.network(newsList[pos].image)),
          ],
        ),
      ),
    );
  }

  _onItemClick(int pos) {
    if (newsList != null && newsList.length > pos) {
      launchURL(url: Uri.encodeFull(newsList[pos].link));
    }
  }

  Widget getItemBottomWidget(int pos) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Expanded(
            child: Text(
                "${I18n.of(context).forumCreate}${newsList[pos].author}",
                style: StyleFactory.forumItemLabelFontStyle)),
      ],
    );
  }
}

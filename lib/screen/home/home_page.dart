import 'package:badges/badges.dart';
import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/routes/routes.dart';
import 'package:bbb_flutter/screen/home/banner_widget.dart';
import 'package:bbb_flutter/screen/home/home_app_bar.dart';
import 'package:bbb_flutter/screen/home/home_ranking_item_builder.dart';
import 'package:bbb_flutter/screen/home/home_view_model.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oktoast/oktoast.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _currentTabIndex = 0;
  TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index.toDouble() == _tabController.animation.value) {
        setState(() {
          _currentTabIndex = _tabController.index;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<HomeViewModel>(
      model: locator.get<HomeViewModel>(),
      onModelReady: (homeViewMode) {
        homeViewMode.getBanners();
        homeViewMode.getRankingList();
        homeViewMode.startLoop();
        homeViewMode.getZendeskAdvertise();
        homeViewMode.getGatewayInfo(assetName: AssetName.USDTERC20);
        // homeViewMode.getAstrologyPredict();
      },
      builder: (context, homeViewModel, child) {
        return Scaffold(
          backgroundColor: Palette.appDividerBackgroudGreyColor,
          appBar: homePageAppBar(context),
          body: Stack(
            children: <Widget>[
              Container(
                  child: Image.asset(R.resAssetsIconsIcHomeBackground),
                  alignment: Alignment.bottomCenter),
              extended.NestedScrollView(
                  physics: BouncingScrollPhysics(),
                  headerSliverBuilder: (context, value) {
                    return [
                      SliverToBoxAdapter(
                        child: Container(
                            color: Colors.white,
                            child: Column(
                              children: <Widget>[
                                BannerWidget(items: homeViewModel.banners),
                                Container(
                                  margin: EdgeInsets.fromLTRB(16, 20, 16, 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      SvgPicture.asset(
                                        R.resAssetsIconsIcHomeMarquee,
                                        width: 20,
                                        height: 20,
                                      ),
                                      Container(
                                        height: 30,
                                        margin: EdgeInsets.only(left: 6),
                                        child: homeViewModel
                                                .zendeskAdvertise.isEmpty
                                            ? Container()
                                            : CarouselSlider(
                                                scrollPhysics:
                                                    NeverScrollableScrollPhysics(),
                                                aspectRatio: 10 / 1,
                                                scrollDirection: Axis.vertical,
                                                autoPlay: true,
                                                items: homeViewModel
                                                    .zendeskAdvertise
                                                    .map((i) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      if (i.htmlUrl == null ||
                                                          i.htmlUrl.isEmpty) {
                                                        return;
                                                      }
                                                      if (i.htmlUrl.contains(
                                                          HTTPString)) {
                                                        launchURL(
                                                            url: Uri.encodeFull(
                                                                i.htmlUrl));
                                                      } else {
                                                        Navigator.of(context)
                                                            .pushNamed(
                                                                i.htmlUrl);
                                                      }
                                                    },
                                                    child: Text(i.name,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: StyleNewFactory
                                                            .grey15),
                                                  );
                                                }).toList(),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          padding: EdgeInsets.only(
                              right: 15, left: 15, top: 12, bottom: 12),
                          child: Column(
                            children: <Widget>[
                              // Container(
                              //   alignment: Alignment.centerLeft,
                              //   child: Text(
                              //     I18n.of(context).homeAstrology,
                              //     style: StyleNewFactory.black18,
                              //   ),
                              // ),
                              // SizedBox(
                              //   height: 12,
                              // ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () =>
                                          homeViewModel.checkGuess(context),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              width: double.infinity,
                                              child: SvgPicture.asset(
                                                R.resAssetsIconsIcGuessUpDown,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () =>
                                          homeViewModel.checkDeposit(context),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Stack(
                                          children: <Widget>[
                                            Container(
                                              width: double.infinity,
                                              child: SvgPicture.asset(
                                                R.resAssetsIconsIcHomeDeposit,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ];
                  },
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        color: Colors.white,
                        width: ScreenUtil.screenWidthDp,
                        child: TabBar(
                          isScrollable: true,
                          controller: _tabController,
                          indicatorSize: TabBarIndicatorSize.label,
                          labelColor: Palette.appBlack,
                          unselectedLabelColor: Palette.appGrey,
                          labelStyle: StyleNewFactory.black15,
                          unselectedLabelStyle: StyleNewFactory.grey15,
                          indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(
                                color: Palette.invitePromotionBadgeColor,
                                width: 2),
                            insets: EdgeInsets.fromLTRB(0, 0.0, 0, 8),
                          ),
                          onTap: (index) {},
                          tabs: <Widget>[
                            Tab(
                              child: Badge(
                                showBadge: _currentTabIndex == 0,
                                position:
                                    BadgePosition.topRight(top: 5, right: -22),
                                badgeColor: Palette.appYellowOrange,
                                badgeContent:
                                    Text("24H", style: StyleNewFactory.white9),
                                shape: BadgeShape.square,
                                padding: EdgeInsets.all(1),
                                child: Text(
                                    I18n.of(context).homeSingleOrderRanking),
                              ),
                            ),
                            Tab(
                              child: Badge(
                                showBadge: _currentTabIndex == 1,
                                position:
                                    BadgePosition.topRight(top: 5, right: -22),
                                badgeColor: Palette.appYellowOrange,
                                badgeContent:
                                    Text("24H", style: StyleNewFactory.white9),
                                shape: BadgeShape.square,
                                padding: EdgeInsets.all(1),
                                child: Text(
                                    I18n.of(context).homeTotalOrderRanking),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: <Widget>[
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: 11,
                              itemBuilder: (context, index) {
                                return HomeRankingItem(
                                  index: index,
                                  rankingResponse: (index == 0 ||
                                          index >=
                                              homeViewModel
                                                      .rankingsTotal.length +
                                                  1)
                                      ? null
                                      : homeViewModel.rankingsTotal[index - 1],
                                );
                              },
                            ),
                            ListView.builder(
                              itemCount: 11,
                              itemBuilder: (context, index) {
                                return HomeRankingItem(
                                  index: index,
                                  rankingResponse: (index == 0 ||
                                          index >=
                                              homeViewModel
                                                      .rankingsPerorder.length +
                                                  1)
                                      ? null
                                      : homeViewModel
                                          .rankingsPerorder[index - 1],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        );
      },
    );
  }
}

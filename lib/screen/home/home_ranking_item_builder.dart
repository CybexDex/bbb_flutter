import 'package:bbb_flutter/helper/utils.dart';
import 'package:bbb_flutter/models/response/ranking_response_model.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter_svg/svg.dart';

class HomeRankingItem extends StatelessWidget {
  final int index;
  final RankingResponse _rankingResponse;
  HomeRankingItem({Key key, int index, RankingResponse rankingResponse})
      : this.index = index,
        _rankingResponse = rankingResponse,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (index == 0) {
      return Container(
        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
        color: Color(0xfff7f7f7),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Text("排名", style: StyleNewFactory.grey12),
            ),
            Expanded(
              flex: 2,
              child: Text("用户", style: StyleNewFactory.grey12),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Text("收益", style: StyleNewFactory.grey12),
            )
          ],
        ),
      );
    }
    return Container(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: index < 4
                  ? _getRankingIcon(index: index)
                  : Container(
                      padding: EdgeInsets.only(left: 6),
                      child: Text(index.toString()),
                    )),
          Expanded(
            flex: 2,
            child: Text(getEllipsisName(value: _rankingResponse?.name) ?? "--",
                style: StyleNewFactory.grey14),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
            decoration: BoxDecoration(
                color: Palette.appYellowOrange,
                borderRadius: BorderRadius.circular(4)),
            child: Text(
                _rankingResponse == null
                    ? "--"
                    : "${(_rankingResponse.pnlRatio * 100).toStringAsFixed(2)} %",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  letterSpacing: 0,
                )),
          )
        ],
      ),
    );
  }

  Widget _getRankingIcon({int index}) {
    switch (index) {
      case 1:
        return SvgPicture.asset(
          R.resAssetsIconsIcRank1,
          alignment: Alignment.centerLeft,
          width: 20,
          height: 25,
        );
      case 2:
        return SvgPicture.asset(
          R.resAssetsIconsIcRank2,
          alignment: Alignment.centerLeft,
          width: 20,
          height: 25,
        );
      case 3:
        return SvgPicture.asset(
          R.resAssetsIconsIcRank3,
          alignment: Alignment.centerLeft,
          width: 20,
          height: 25,
        );
      default:
        return Container();
    }
  }
}

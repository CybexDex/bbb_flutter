import 'package:bbb_flutter/localization/i18n.dart';
import 'package:bbb_flutter/shared/palette.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter/material.dart';

class OrderRecordDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Palette.backButtonColor, //change your color here
          ),
          centerTitle: true,
          title: Text(I18n.of(context).transactionRecords,
              style: StyleFactory.title),
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: OrderRecordDetailInfo(),
        ));
  }
}

class OrderRecordDetailHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 106,
      padding: new EdgeInsets.fromLTRB(20, 0, 20, 0),
      decoration: new BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Color(0x1a000000),
                offset: Offset(0.0, 4.0),
                blurRadius: 12.0)
          ],
          borderRadius: BorderRadius.circular(4.0)),
      child: new Column(
        children: <Widget>[
          new Container(
            height: 53,
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Text("买涨",
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0)),
              ],
            ),
          ),
          new Container(
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Text("+2.1000",
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                        fontSize: 24.0)),
                new Text("   USDT",
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0))
              ],
            ),
          )
        ],
      ),
    );
  }
}

class OrderRecordDetailInfo extends StatelessWidget {
  final titles = [
    "建仓价格",
    "平仓价格",
    "投资总额",
    "手续费",
    "杠杆",
    "止盈",
    "止损",
    "建仓时间",
    "平仓时间",
    "平仓类型"
  ];
  @override
  Widget build(BuildContext context) {
    _itemBuilder(title, index) {
      if (index == 0) {
        return new OrderRecordDetailHeader();
      }
      return new ListTile(
        contentPadding: EdgeInsets.zero,
        title: new Text(
          title,
          style: new TextStyle(
              color: Color(0xff666666),
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              fontSize: 14.0),
        ),
        trailing: new Text("text",
            style: TextStyle(
                color: Color(0xff333333),
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 14.0)),
      );
    }

    return new ListView.separated(
      itemBuilder: (BuildContext build, int position) {
        return _itemBuilder(this.titles[position], position);
      },
      separatorBuilder: (BuildContext build, int position) {
        if (position != 0) {
          return Divider(
            height: 1,
            color: Color(0xffdddddd),
          );
        }
        return Container();
      },
      itemCount: this.titles.length,
    );
  }
}

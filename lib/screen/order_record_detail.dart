import 'package:bbb_flutter/localization/i18n.dart';
import 'package:bbb_flutter/shared/palette.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter/material.dart';

class OrderRecordDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<int>().catchError(onError)
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Palette.backButtonColor, //change your color here
          ),
          centerTitle: true,
          title:
              Text(I18n.of(context).tradingDetail, style: StyleFactory.title),
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
    return  Container(
      height: 106,
      padding:  EdgeInsets.fromLTRB(20, 0, 20, 0),
      decoration:  BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Color(0x1a000000),
                offset: Offset(0.0, 4.0),
                blurRadius: 12.0)
          ],
          borderRadius: BorderRadius.circular(4.0)),
      child:  Column(
        children: <Widget>[
           Container(
            height: 53,
            child:  Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                 Text(I18n.of(context).buyUp,
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0)),
              ],
            ),
          ),
           Container(
            child:  Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                 Text("+2.1000",
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                        fontSize: 24.0)),
                 Text("   USDT",
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
    I18n.of(globalKey.currentContext).openPositionPrice,
    I18n.of(globalKey.currentContext).settlementPrice,
    I18n.of(globalKey.currentContext).investAmount,
    I18n.of(globalKey.currentContext).fee,
    I18n.of(globalKey.currentContext).leverage,
    I18n.of(globalKey.currentContext).takeProfit,
    I18n.of(globalKey.currentContext).cutLoss,
    I18n.of(globalKey.currentContext).openPositionTime,
    I18n.of(globalKey.currentContext).settlementTime,
    I18n.of(globalKey.currentContext).settlementType
  ];
  @override
  Widget build(BuildContext context) {
    _itemBuilder(title, index) {
      if (index == 0) {
        return  OrderRecordDetailHeader();
      }
      return  ListTile(
        contentPadding: EdgeInsets.zero,
        title:  Text(
          title,
          style:  TextStyle(
              color: Color(0xff666666),
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              fontSize: 14.0),
        ),
        trailing:  Text("text",
            style: TextStyle(
                color: Color(0xff333333),
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 14.0)),
      );
    }

    return  ListView.separated(
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

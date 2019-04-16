import 'package:bbb_flutter/common/image_factory.dart';
import 'package:bbb_flutter/common/style_factory.dart';
import 'package:bbb_flutter/common/widget_factory.dart';
import 'package:flutter/material.dart';

import 'istep.dart';

class OrderInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: ImageFactory.upIcon14,
              ),
              Text(
                ".BXBT",
                style: StyleFactory.smallCellTitleStyle,
              ),
              Expanded(
                  child: Align(
                alignment: Alignment.centerRight,
                child: WidgetFactory.smallButton(data: "平仓", onPressed: () {}),
              )),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Text(
                "当前预计收益",
                style: StyleFactory.subTitleStyle,
              ),
              Text(
                "23 USDT≈213 RMB",
                style: StyleFactory.smallCellTitleStyle,
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Text(
                "实际杠杆",
                style: StyleFactory.subTitleStyle,
              ),
              Text(
                "0.0001 USDT / 50%",
                style: StyleFactory.smallCellTitleStyle,
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Text(
                "投资",
                style: StyleFactory.subTitleStyle,
              ),
              Text(
                "23 USDT≈213 RMB",
                style: StyleFactory.smallCellTitleStyle,
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Text(
                "止盈/止损",
                style: StyleFactory.subTitleStyle,
              ),
              Expanded(
                  child: Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text(
                        "50% / 50%",
                        style: StyleFactory.smallCellTitleStyle,
                      ),
                    ),
                    WidgetFactory.smallButton(data: "修改", onPressed: () {}),
                  ],
                ),
              )),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Text(
                "自动平仓时间",
                style: StyleFactory.subTitleStyle,
              ),
              Text(
                "2019.04.01 14:00",
                style: StyleFactory.smallCellTitleStyle,
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

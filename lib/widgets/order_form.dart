import 'package:bbb_flutter/common/style_factory.dart';
import 'package:flutter/material.dart';

import 'istep.dart';

class OrderForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                "当前每份价格",
                style: StyleFactory.subTitleStyle,
              ),
              Text(
                "90 USDT",
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
                "剩余份数",
                style: StyleFactory.subTitleStyle,
              ),
              Text(
                "21 份",
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
                "投资份数",
                style: StyleFactory.subTitleStyle,
              ),
              SizedBox(width: 76, child: IStep(text: "0"),)
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Text(
                "止盈",
                style: StyleFactory.subTitleStyle,
              ),
              SizedBox(width: 76, child: IStep(text: "50%"),)
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Text(
                "止盈收益",
                style: StyleFactory.subTitleStyle,
              ),
              Text(
                "4 USDT",
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
                "止损",
                style: StyleFactory.subTitleStyle,
              ),
              SizedBox(width: 76, child: IStep(text: "50%"),)
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Text(
                "止损亏损",
                style: StyleFactory.subTitleStyle,
              ),
              Text(
                "4 USDT",
                style: StyleFactory.smallCellTitleStyle,
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ],
      ),
    );
  }
}

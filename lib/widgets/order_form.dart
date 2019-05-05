import 'package:bbb_flutter/common/style_factory.dart';
import 'package:bbb_flutter/generated/i18n.dart';
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
                I18n.of(context).per_price,
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
                I18n.of(context).rest_amount,
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
                I18n.of(context).invest_amount,
                style: StyleFactory.subTitleStyle,
              ),
              SizedBox(
                width: 76,
                child: IStep(text: "0"),
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
                I18n.of(context).take_profit,
                style: StyleFactory.subTitleStyle,
              ),
              SizedBox(
                width: 76,
                child: IStep(text: "50%"),
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
                "${I18n.of(context).take_profit}${I18n.of(context).gain}",
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
                I18n.of(context).cut_loss,
                style: StyleFactory.subTitleStyle,
              ),
              SizedBox(
                width: 76,
                child: IStep(text: "50%"),
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
                "${I18n.of(context).cut_loss}${I18n.of(context).loss}",
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

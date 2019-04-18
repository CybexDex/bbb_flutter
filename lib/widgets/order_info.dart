import 'package:bbb_flutter/common/image_factory.dart';
import 'package:bbb_flutter/common/style_factory.dart';
import 'package:bbb_flutter/common/widget_factory.dart';
import 'package:bbb_flutter/generated/i18n.dart';
import 'package:flutter/material.dart';

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
                child: WidgetFactory.smallButton(
                    data: S.of(context).close_out, onPressed: () {}),
              )),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Text(
                S.of(context).future_profit,
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
                S.of(context).act_level,
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
                S.of(context).invest,
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
                "${S.of(context).take_profit}/${S.of(context).cut_loss}",
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
                    WidgetFactory.smallButton(
                        data: S.of(context).amend, onPressed: () {}),
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
                S.of(context).force_expiration,
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

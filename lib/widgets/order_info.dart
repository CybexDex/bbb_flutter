import 'package:bbb_flutter/common/widget_factory.dart';
import 'package:flutter/material.dart';

class OrderInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          Row(
            children: <Widget>[Text("当前预计收益"), Text("23 USDT≈213 RMB")],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          Row(
            children: <Widget>[Text("当前预计收益"), WidgetFactory.smallButton(data: "平仓", onPressed: (){})],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          Row(
            children: <Widget>[Text("当前预计收益"), Text("23 USDT≈213 RMB")],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          Row(
            children: <Widget>[Text("当前预计收益"), Text("23 USDT≈213 RMB")],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          Row(
            children: <Widget>[Text("当前预计收益"), Text("23 USDT≈213 RMB")],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          )
        ],
      ),
    );
  }
}

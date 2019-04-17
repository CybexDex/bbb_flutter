import 'package:bbb_flutter/common/image_factory.dart';
import 'package:bbb_flutter/common/style_factory.dart';
import 'package:flutter/material.dart';

class IStep extends StatelessWidget {
  final GestureTapCallback minusOnTap;
  final GestureTapCallback plusOnTap;
  final String text;

  IStep({Key key, this.text, this.minusOnTap, this.plusOnTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
              child: Container(
                child: ImageFactory.countReduce,
              ),
              onTap: minusOnTap),
          Text(
            "$text",
            style: StyleFactory.smallCellTitleStyle,
          ),
          GestureDetector(
              child: Container(
                child: ImageFactory.countAdd,
              ),
              onTap: plusOnTap)
        ],
      ),
    );
  }
}

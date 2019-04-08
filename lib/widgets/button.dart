import 'package:bbb_flutter/colors/palette.dart';
import 'package:flutter/material.dart';
import 'package:bbb_flutter/generated/i18n.dart';

class ActionButton extends StatefulWidget {
  Color background = Palette.redOrange;
  ActionButton({Key key, this.background}): super(key: key);

  @override
  State<StatefulWidget> createState() => _ActionButtonState(price: "");
}

class _ActionButtonState extends State<ActionButton> {
  String price = "--";

  _ActionButtonState({this.price});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      textColor: Color.fromRGBO(0, 0, 0, 1),
      onPressed: () {} ,

      child: Text(
        S.of(context).buy_up_price(price),
        style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontStyle:  FontStyle.normal,
            fontSize: 16.0
        ),
      ),
    );
  }
}
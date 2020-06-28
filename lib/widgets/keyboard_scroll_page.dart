import 'package:flutter/widgets.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';

class KeyboardScrollPage extends StatelessWidget {
  final Widget widget;
  final double appbarHeight;

  KeyboardScrollPage({Key key, Widget widget, double appbarHeight})
      : this.widget = widget,
        this.appbarHeight = appbarHeight,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return KeyboardAvoider(
      autoScroll: true,
      focusPadding: appbarHeight ?? double.infinity,
      child: Container(child: widget),
    );
  }
}

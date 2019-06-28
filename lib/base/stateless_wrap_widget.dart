import 'package:bbb_flutter/shared/ui_common.dart';

class StateLessWrapWidget extends StatefulWidget {
  final Widget child;
  final Function() onReady;

  StateLessWrapWidget({Key key, this.child, this.onReady}) : super(key: key);
  @override
  _StateLessWrapWidgetState createState() => _StateLessWrapWidgetState();
}

class _StateLessWrapWidgetState extends State<StateLessWrapWidget> {
  @override
  void initState() {
    if (widget.onReady != null) {
      widget.onReady();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

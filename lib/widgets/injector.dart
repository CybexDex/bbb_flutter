import 'package:flutter/material.dart';

class InjectorWidget extends InheritedWidget {
  InjectorWidget({
    Key key,
    @required Widget child,
  }) : assert(child != null),
        super(key: key, child: child);

  static InjectorWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(InjectorWidget) as InjectorWidget;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  init() async {

  }

}

import 'package:bbb_flutter/shared/palette.dart';
import 'package:bbb_flutter/shared/style_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../r.dart';

class StaggerAnimation extends StatelessWidget {
  StaggerAnimation({Key key, this.controller, this.accountName, this.pnl})
      :

        // Each animation defined here transforms its value during the subset
        // of the controller's duration defined by the animation's interval.
        // For example the opacity animation transforms its value during
        // the first 10% of the controller's duration.

        opacity = Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.3,
              0.6,
              curve: Curves.ease,
            ),
          ),
        ),
        move = Tween<Offset>(begin: Offset(1.2, 0), end: Offset.zero).animate(
            CurvedAnimation(
                parent: controller,
                curve: Interval(0, 0.1, curve: Curves.easeInOut))),
        super(key: key);

  final Animation<double> controller;
  final Animation<double> opacity;
  final Animation<Offset> move;
  final double pnl;
  final String accountName;

  // This function is called each time the controller "ticks" a new frame.
  // When it runs, all of the animation's values will have been
  // updated to reflect the controller's current value.
  Widget _buildAnimation(BuildContext context, Widget child) {
    return Container(
      width: 200,
      alignment: Alignment.bottomCenter,
      child: Opacity(
        opacity: opacity.value,
        child: SlideTransition(
          position: move,
          child: Container(
            padding: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
                color: Palette.veryLightPink,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Row(
              children: <Widget>[
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(45))),
                    ),
                    Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: Palette.veryLightPink,
                            borderRadius:
                                BorderRadius.all(Radius.circular(45))),
                        child: SvgPicture.asset(R.resAssetsIconsIcNews)),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 7),
                  child: Text(
                    "$accountName 盈利",
                    style: StyleFactory.subTitleStyle,
                  ),
                ),
                Text(
                  "${pnl.toStringAsFixed(4)} USDT",
                  style: StyleFactory.buyUpText,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}

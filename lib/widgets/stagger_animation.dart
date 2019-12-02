import 'package:bbb_flutter/helper/utils.dart';
import 'package:bbb_flutter/shared/palette.dart';
import 'package:bbb_flutter/shared/style_factory.dart';
import 'package:flutter/material.dart';

class StaggerAnimation extends StatelessWidget {
  StaggerAnimation(
      {Key key, this.controller, this.accountName, this.pnl, this.isUp})
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
  final bool isUp;

  // This function is called each time the controller "ticks" a new frame.
  // When it runs, all of the animation's values will have been
  // updated to reflect the controller's current value.
  Widget _buildAnimation(BuildContext context, Widget child) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Opacity(
        opacity: opacity.value,
        child: SlideTransition(
          position: move,
          child: Container(
            padding: EdgeInsets.only(right: 10, top: 4, bottom: 4, left: 10),
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Row(
              children: <Widget>[
                // Stack(
                //   alignment: Alignment.center,
                //   children: <Widget>[
                //     Container(
                //       width: 22,
                //       height: 22,
                //       decoration: BoxDecoration(
                //           color: Colors.black.withOpacity(0.5),
                //           borderRadius: BorderRadius.all(Radius.circular(45))),
                //     ),
                //     Container(
                //         width: 20,
                //         height: 20,
                //         decoration: BoxDecoration(
                //             color: Colors.black.withOpacity(0.5),
                //             borderRadius:
                //                 BorderRadius.all(Radius.circular(45))),
                //         child: SvgPicture.asset(R.resAssetsIconsIcNews)),
                //   ],
                // ),
                Container(
                  child: Text("${getEllipsisName(value: accountName)} 盈利  ",
                      style: StyleFactory.pnlBroadCastStyle),
                ),
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: isUp ? Palette.redOrange : Palette.shamrockGreen,
                      borderRadius: BorderRadius.all(Radius.circular(45))),
                  child: Text("${pnl.toStringAsFixed(4)} USDT",
                      style: StyleFactory.pnlBroadCastStyle),
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

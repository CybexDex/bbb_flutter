import 'package:bbb_flutter/helper/ui_utils.dart';
import 'package:bbb_flutter/helper/utils.dart';
import 'package:bbb_flutter/models/response/account_banner_response_model.dart';
import 'package:bbb_flutter/shared/palette.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';

class BannerWidget extends StatefulWidget {
  final List<BannerResponse> items;
  BannerWidget({Key key, List<BannerResponse> items})
      : this.items = items,
        super(key: key);
  @override
  State<BannerWidget> createState() {
    return BannerState();
  }
}

class BannerState extends State<BannerWidget> {
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CarouselSlider(
            viewportFraction: 0.92,
            autoPlay: widget.items.length > 1,
            aspectRatio: 300 / 145,
            reverse: false,
            enlargeCenterPage: true,
            enableInfiniteScroll: widget.items.length > 1,
            autoPlayAnimationDuration: Duration(seconds: 2),
            onPageChanged: (index) {
              setState(() {
                _current = index;
              });
            },
            items: widget.items.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    margin: EdgeInsets.all(8),
                    constraints: BoxConstraints.expand(),
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(color: Color(0xffe2e2e2), blurRadius: 6, offset: Offset(0, 3))
                    ], borderRadius: BorderRadius.circular(10)),
                    child: GestureDetector(
                        onTap: () {
                          jumpToUrl(Uri.encodeFull(i.link), context,
                              needLogIn: i.needUserName == "1");
                        },
                        child: showNetworkImageWrapper(
                          url: i.image,
                          fit: BoxFit.fill,
                        )),
                  );
                },
              );
            }).toList()),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.items
              .asMap()
              .map((i, element) {
                return MapEntry(
                    i,
                    _current == i
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 2.5),
                            width: 10,
                            height: 3,
                            decoration: BoxDecoration(color: Palette.appYellowOrange))
                        : new Container(
                            margin: EdgeInsets.symmetric(horizontal: 2.5),
                            width: 4,
                            height: 3,
                            decoration:
                                new BoxDecoration(color: Color(0xffcccccc).withOpacity(0.5))));
              })
              .values
              .toList(),
        ),
      ],
    );
  }
}

import 'package:bbb_flutter/helper/show_dialog_utils.dart';
import 'package:bbb_flutter/models/response/account_banner_response_model.dart';
import 'package:bbb_flutter/shared/defs.dart';
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
            aspectRatio: 320 / 165,
            autoPlay: widget.items.length > 1,
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
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: GestureDetector(
                          onTap: () {
                            if (i.link == null ||
                                i.link.isEmpty ||
                                i.link == "empty") {
                              return;
                            }
                            if (i.link.contains(HTTPString)) {
                              launchURL(url: Uri.encodeFull(i.link));
                            } else {
                              Navigator.of(context).pushNamed(i.link);
                            }
                          },
                          child: Image.network(
                            i.image,
                            fit: BoxFit.fill,
                          )));
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
                            margin: EdgeInsets.fromLTRB(2.5, 10, 2.5, 0),
                            width: 10,
                            height: 3,
                            decoration: BoxDecoration(color: Color(0xffffbd00)))
                        : new Container(
                            margin: EdgeInsets.fromLTRB(2.5, 10, 2.5, 0),
                            width: 4,
                            height: 3,
                            decoration: new BoxDecoration(
                                color: Color(0xffcccccc).withOpacity(0.5))));
              })
              .values
              .toList(),
        ),
      ],
    );
  }
}

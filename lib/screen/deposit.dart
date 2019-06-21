import 'package:bbb_flutter/manager/user_manager.dart';
import 'package:bbb_flutter/models/response/deposit_response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:bbb_flutter/shared/ui_common.dart';

class DepositPage extends StatelessWidget {
  const DepositPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userName = locator<UserManager>().user.name;
    // depositBloc.getDeposit(name: userName, asset: "USDT");
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Palette.backButtonColor, //change your color here
        ),
        centerTitle: true,
        title: Text(I18n.of(context).topUp, style: StyleFactory.title),
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 0,
      ),
      body: SafeArea(
          child: Container(
              // margin: Dimen.pageMargin,
              // child: StreamBuilder<DepositResponseModel>(
              //   stream: depositBloc.depositBloc.stream,
              //   builder: (context, snapShot) {
              //     if (snapShot != null && snapShot.hasData) {
              //       return Container(
              //           alignment: Alignment.center,
              //           margin: EdgeInsets.only(top: 40),
              //           child: Column(
              //             children: <Widget>[
              //               QrImage(
              //                 data: snapShot.data.address,
              //                 size: 155,
              //               ),
              //               SizedBox(height: 20),
              //               Text("保存二维码", style: StyleFactory.hyperText),
              //               SizedBox(height: 20),
              //               Container(
              //                   decoration: BoxDecoration(
              //                     border: Border.all(
              //                         width: 1, color: Palette.separatorColor),
              //                     borderRadius:
              //                         BorderRadius.all(Radius.circular(5.0) //
              //                             ),
              //                   ),
              //                   padding: EdgeInsets.only(
              //                       left: 20, top: 20, right: 20, bottom: 20),
              //                   child: Column(
              //                     children: <Widget>[
              //                       Text(snapShot.data.address),
              //                       Container(
              //                         margin: EdgeInsets.only(top: 10),
              //                         alignment: Alignment.bottomRight,
              //                         child: Text("点击复制",
              //                             style: StyleFactory.hyperText),
              //                       )
              //                     ],
              //                   )),
              //               Container(
              //                 margin: EdgeInsets.only(top: 20),
              //                 decoration: BoxDecoration(
              //                   color: Palette.veryLightPinkTwo,
              //                   borderRadius:
              //                       BorderRadius.all(Radius.circular(4.0) //
              //                           ),
              //                 ),
              //                 child: Text("请勿向该地址转账非USDT资产",
              //                     style: StyleFactory.subTitleStyle),
              //               )
              //             ],
              //           ));
              //     }
              //     return Container();
              //   },
              // )
              )),
    );
  }
}

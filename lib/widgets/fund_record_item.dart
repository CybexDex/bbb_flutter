import 'package:bbb_flutter/models/response/fund_record_model.dart';
import 'package:bbb_flutter/shared/defs.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class FundRecordItem extends StatelessWidget {
  final FundRecordModel _model;
  FundRecordItem({FundRecordModel model, Key key})
      : _model = model,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDeposit = fundTypeMap[_model.subtype] == FundType.userDepositExtern;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Image.asset(R.resAssetsIconsIcUsdt),
                    ),
                    Text(AssetName.USDT, style: StyleNewFactory.grey14)
                  ],
                ),
                Text("${_model.amount} ${AssetName.USDT}",
                    style: StyleNewFactory.black15)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  DateFormat("yyyy-MM-dd    HH:mm:ss")
                      .format(DateTime.parse(_model.time).toLocal()),
                  style: StyleNewFactory.appCellTitleLightGrey14,
                ),
                Row(
                  children: <Widget>[
                    SvgPicture.asset(
                      isDeposit
                          ? R.resAssetsIconsIcDeposit
                          : R.resAssetsIconsIcWithdraw,
                      color: Palette.appYellowOrange,
                      width: 13,
                      height: 15,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    // Text(fundStatusCN(_model.status),
                    //     style:
                    //         _model.status == fundStatusMap[FundStatus.completed]
                    //             ? StyleNewFactory.green15
                    //             : StyleNewFactory.black15),
                  ],
                ),
              ],
            ),
          ),
          Text(
            "${_model.custom.replaceAll(RegExp(r'[{\"}]'), "")}",
            // "${I18n.of(context).address} ${_model.address}",
            style: StyleNewFactory.grey12,
          ),
        ],
      ),
    );
  }
}

import 'package:bbb_flutter/models/response/fund_record_model.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:intl/intl.dart';

class FundRecordItem extends StatelessWidget {
  final FundRecordModel _model;
  FundRecordItem({FundRecordModel model, Key key})
      : _model = model,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDeposit = fundTypeMap[_model.type] == FundType.userDepositExtern;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
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
                    Text(
                      "USDT",
                      style: StyleFactory.dialogContentStyle,
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Image.asset(isDeposit
                        ? R.resAssetsIconsIcTabDeposit
                        : R.resAssetsIconsIcTabWithdraw),
                    Text("${_model.amount} ${_model.assetName}",
                        style: StyleFactory.cellTitleStyle),
                  ],
                )
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
                  DateFormat("${I18n.of(context).updatedDate}: MM.dd HH:mm:ss")
                      .format(_model.lastUpdateTime.toLocal()),
                  style: StyleFactory.cellDescLabel,
                ),
                Text(
                  fundStatusCN(_model.status),
                  style: StyleFactory.cellDescLabel,
                ),
              ],
            ),
          ),
          Text(
            "${I18n.of(context).address}: ${_model.address}",
            style: StyleFactory.cellDescLabel,
          ),
        ],
      ),
    );
  }
}

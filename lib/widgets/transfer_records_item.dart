import 'package:bbb_flutter/models/response/fund_record_model.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:intl/intl.dart';

class TransferRecordsItem extends StatelessWidget {
  final FundRecordModel _model;
  TransferRecordsItem({FundRecordModel model, Key key})
      : _model = model,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isTranferIn = fundTypeMap[_model.subtype] == FundType.userDepositCybex;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                isTranferIn ? "CYBEX账户→BBB账号" : "BBB账户→CYBEX账户",
                style: StyleNewFactory.black15,
              ),
              Text(
                DateFormat("yyyy-MM-dd    HH:mm:ss").format(DateTime.parse(_model.time).toLocal()),
                style: StyleNewFactory.grey13,
              )
            ],
          ),
          Text("${_model.amount.toStringAsFixed(4)}", style: StyleNewFactory.yellowOrange18),
        ],
      ),
    );
  }
}

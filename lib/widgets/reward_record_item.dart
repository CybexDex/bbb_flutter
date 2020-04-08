import 'package:bbb_flutter/logic/reward_records_vm.dart';
import 'package:bbb_flutter/models/response/fund_record_model.dart';
import 'package:bbb_flutter/shared/style_new_standard_factory.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class RewardRecordItem extends StatelessWidget {
  final FundRecordModel _model;
  final RewardRecordsViewModel _vm;
  RewardRecordItem({FundRecordModel model, Key key, RewardRecordsViewModel vm})
      : _model = model,
        _vm = vm,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              SvgPicture.asset(
                R.resAssetsIconsUsdtIcon,
                width: 30,
                height: 30,
              ),
              SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "USDT--${_model.description}",
                    style: StyleNewFactory.black15,
                  ),
                  Text(
                    DateFormat("yyyy-MM-dd    HH:mm:ss")
                        .format(DateTime.parse(_model.time).toLocal()),
                    style: StyleNewFactory.grey13,
                  )
                ],
              ),
            ],
          ),
          Text("+${_model.amount.toStringAsFixed(4)}", style: StyleNewFactory.green15),
        ],
      ),
    );
  }
}

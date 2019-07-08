import 'package:bbb_flutter/helper/ui_utils.dart';
import 'package:bbb_flutter/models/response/order_response_model.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:intl/intl.dart';

class OrderRecordItem extends StatelessWidget {
  OrderResponseModel _model;
  OrderRecordItem({OrderResponseModel model, Key key})
      : _model = model,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isN = _model.contractId.contains("N");
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
                      child: getPnlIcon(isN),
                    ),
                    Text(
                      isN ? I18n.of(context).buyUp : I18n.of(context).buyDown,
                      style: StyleFactory.dialogContentStyle,
                    )
                  ],
                ),
                Text(
                  (_model.pnl * _model.qtyContract).toStringAsFixed(6) +
                      " USDT",
                  style: isN
                      ? StyleFactory.buyUpCellLabel
                      : StyleFactory.buyDownCellLabel,
                )
              ],
            ),
          ),
          Text(
            DateFormat("MM.dd HH:mm:ss").format(_model.createTime.toLocal()),
            style: StyleFactory.cellDescLabel,
          )
        ],
      ),
    );
  }
}

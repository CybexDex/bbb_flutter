import 'package:bbb_flutter/models/response/bbb_query_response/contract_response.dart';
import 'package:bbb_flutter/models/response/positions_response_model.dart';
import 'package:bbb_flutter/widgets/custom_dropdown.dart';

import 'order_form_model.dart';

class LimitOrderForm {
  int investAmount;
  double predictPrice;
  String contractId;
  double takeProfit;
  double takeProfitPx;
  List<DropdownMenuItem<Contract>> dropdownMenuItems;
  Contract selectedItem;
  bool isUp;
  bool showProfit;
  bool showCutoff;
  Position cybBalance;

  Asset totalAmount;
  Asset fee;

  LimitOrderForm(
      {this.investAmount,
      this.predictPrice,
      this.takeProfit,
      this.takeProfitPx,
      this.contractId,
      this.dropdownMenuItems,
      this.selectedItem,
      this.isUp,
      this.fee,
      this.totalAmount,
      this.showCutoff,
      this.showProfit,
      this.cybBalance});
}

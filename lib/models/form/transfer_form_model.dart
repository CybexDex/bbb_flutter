import 'package:bbb_flutter/models/response/positions_response_model.dart';

import 'order_form_model.dart';

class TransferForm {
  bool fromBBBToCybex;

  Asset totalAmount;
  Position balance;
  Position cybBalance;

  TransferForm(
      {this.fromBBBToCybex, this.totalAmount, this.balance, this.cybBalance});
}

import 'package:bbb_flutter/models/response/positions_response_model.dart';

import 'order_form_model.dart';

class WithdrawForm {
  Asset totalAmount;
  Position balance;
  String address;
  Position cybBalance;

  WithdrawForm({this.totalAmount, this.balance, this.address, this.cybBalance});
}

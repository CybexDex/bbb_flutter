import 'package:bbb_flutter/models/response/positions_response_model.dart';

import 'order_form_model.dart';

class WithdrawForm {
  Asset totalAmount;
  Position balance;
  String address;

  WithdrawForm({this.totalAmount, this.balance, this.address});
}

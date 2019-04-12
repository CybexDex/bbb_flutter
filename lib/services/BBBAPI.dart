import 'package:bbb_flutter/models/response/ref_contract_response_model.dart';

abstract class BBBAPI {
  Future<RefContractResponseModel> getRefData();
}

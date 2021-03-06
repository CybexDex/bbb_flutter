import 'package:bbb_flutter/models/response/bbb_query_response/contract_response.dart';

class ContractHelper {
  static List<List<Contract>> productsFromContracts(List<Contract> contracts) {
    List<Contract> upContracts = [];
    List<Contract> downContracts = [];

    for (var contract in contracts) {
      if (isUpContract(contract)) {
        upContracts.add(contract);
      } else {
        downContracts.add(contract);
      }
    }

    return [upContracts, downContracts];
  }

  static bool isUpContract(Contract contract) {
    return contract.conversionRate > 0;
  }
}

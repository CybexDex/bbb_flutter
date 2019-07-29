import 'package:cybex_flutter_plugin/order.dart';

class AssetDef {
  static final CYB = AmountToSell(amount: 55, assetId: "0");
  static final CYB_TRANSFER = AmountToSell(amount: 1000, assetId: "0");
}

class AssetName {
  static const CYB = "CYB";
  static const NXUSDT = "NXCO.USDT";
  static const USDT = "USDT";
}

const EmptyString = [null, ""];

class NetworkConnection {
  static const PRO_STANDARD = "https://nxapi.cybex.io/v1";
  static const PRO_TESTNET = "https://nxtestnet.cybex.io/v1";
  static const UAT_STANDARD = "https://nxapiuat.cybex.io/v1";
  static const UAT_TESTNET = "https://nxtestnetuat.cybex.io/v1";
}

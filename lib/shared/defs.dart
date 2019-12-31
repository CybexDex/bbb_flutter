import 'package:cybex_flutter_plugin/order.dart';

class AssetDef {
  static final CYB = AmountToSell(amount: 55, assetId: "0");
  static final CYB_TRANSFER = AmountToSell(amount: 1200, assetId: "0");
}

class AssetName {
  static const CYB = "CYB";
  static const NXUSDT = "NXCO.USDT";
  static const USDT = "USDT";
  static const USDTERC20 = "USDTERC20";
}

class MethodName {
  static const TOTAL_TRANSFER = "get_total_transfer";
  static const TOP_LIST = "get_top10_transfer_by_from_asset_human";
}

class AccountName {
  static const REFER_REBATE_ACCOUNT = "bbb-rebator";
}

class AccountID {
  static const REFER_REBATE_ACCOUNT_ID = "1.2.58267";
}

const EmptyString = [null, ""];
const HTTPString = "https";
const ReferAction = "cybexbbb";

class WebsocketRequestTopic {
  static const FAIRPRICE = "FAIRPRICE";
  static const PNL = "PNL";
  static const NX_PERCENTAGE = "NX_PERCENTAGE";
  static const NX_DAILYPX = "NX_DAILYPX";
}

class NetworkConnection {
  static const PRO_STANDARD = "https://nxapi.cybex.io/v1";
  static const PRO_TESTNET = "https://nxtestnet.cybex.io/v1";
  static const UAT_STANDARD = "https://nxapiuat.cybex.io/v1";
  static const UAT_TESTNET = "https://nxtestnetuat.cybex.io/v1";
}

class GatewayConnection {
  static const PRO_GATEWAY = "https://bbb-gateway.cybex.io";
  static const UAT_GATEWAY = "https://uat-bbb.cybex.io";
}

class FaucetConnection {
  static const PRO_FAUCET = "https://faucetbbb.cybex.io";
  static const UAT_FAUCET = "http://uatfaucet.51nebula.com";
}

class WebSocketConnection {
  static const PRO_WEBSOCKET = "wss://nxmdp.cybex.io";
  static const PRO_TEST_WEBSOCKET = "wss://nxmdp-tn.cybex.io";
  static const UAT_TEST_WEBSOCKET = "wss://nxmdptest-tn.cybex.io";
  static const UAT_WEBSOCKET = "wss://nxmdptest.cybex.io";
}

class ReferSystemConnection {
  static const PRO_REFER = "https://refer.cybex.io";
  static const TEST_REFER = "http://192.168.103.91:8009";
}

class ConfigureConnection {
  static const PRO_CONFIGURE = "https://app.cybex.io";
  static const UAT_CONFIGURE = "http://47.100.98.113:3039";
}

class NodeConnection {
  static const PRO_NODE = "https://normal-hongkong.cybex.io";
  static const UAT_NODE = "http://43.252.132.74:58090";
}

class ForumConnection {
  static const PRO_NODE = "https://guests-cfg.cybex.io";
  static const UAT_NODE = "";
}

class ZenDeskConnection {
  static const PRO_NODE = "https://bbb2019.zendesk.com";
}

class GuessUpDownUrl {
  static const URL = "https://nxapi.cybex.io/v1/newyearguess/?name=";
}

import 'package:cybex_flutter_plugin/order.dart';

class AssetDef {
  static final cyb = AmountToSell(amount: 55, assetId: "0");
  static final cybTransfer = AmountToSell(amount: 1200, assetId: "0");
}

class AssetName {
  static const CYB = "CYB";
  static const NXUSDT = "NXCO.USDT";
  static const USDT = "USDT";
  static const USDTERC20 = "USDTERC20";
}

class AssetId {
  static const USDT = "1.3.27";
  static const CYB = "1.3.0";
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
  static const PNL_MAIN = "PNL.main";
  static const NX_PERCENTAGE_MAIN = "NX_PERCENTAGE.main";
  static const NX_DAILYPX = "NX_DAILYPX";
  static const NX_KLINE = "KLINE";
}

class NetworkConnection {
  static const PRO_STANDARD = "https://nxapi.cybex.io/v1";
  static const PRO_TESTNET = "https://nxtestnet.cybex.io/v1";
  static const UAT_STANDARD = "https://nxapiuat.cybex.io/v1";
  static const UAT_TESTNET = "https://nxtestnetuat.cybex.io/v1";
}

class BBBApiConnection {
  static const PRO = "https://bbb-new.cybex.io";
  // static const PRO = "http://43.252.132.73:55500";
  static const PRO_TEST = "https://bbb-test-new.cybex.io";
  static const PRO_DEV = "http://43.252.132.73:55500";
}

class GatewayConnection {
  static const PRO_GATEWAY = "https://bbbnew-gateway.cybex.io";
  static const UAT_GATEWAY = "https://uat-bbb.cybex.io";
}

class FaucetConnection {
  static const PRO_FAUCET = "https://faucetbbb.cybex.io";
  static const UAT_FAUCET = "http://uatfaucet.51nebula.com";
}

class WebSocketConnection {
  static const PRO_WEBSOCKET = "wss://bbb-new.cybex.io/mdp";
  // static const PRO_WEBSOCKET = "ws://43.252.132.73:55500/mdp";
  static const PRO_TEST_WEBSOCKET = "wss://nxmdp-tn.cybex.io";
  static const UAT_TEST_WEBSOCKET = "wss://nxmdptest-tn.cybex.io";
  static const TEST_WEBSOCKET = "wss://bbb-test-new.cybex.io/mdp";
  static const DEV_WEBSOCKET = "ws://43.252.132.73:55500";
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

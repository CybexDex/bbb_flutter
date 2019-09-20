import 'package:bbb_flutter/shared/ui_common.dart';

String translatePostOrderResponseErrorCode({int code, BuildContext context}) {
  switch (code) {
    case 1001:
      return I18n.of(context).error1001;
    case 1002:
      return I18n.of(context).error1002;
    case 1004:
      return I18n.of(context).error1004;
    case 1005:
      return I18n.of(context).error1005;
    case 1013:
      return I18n.of(context).error1013;
    case 1014:
      return I18n.of(context).error1014;
    case 1016:
      return I18n.of(context).error1016;
    case 1017:
      return I18n.of(context).error1017;
    case 1018:
      return I18n.of(context).error1018;
    case 1019:
      return I18n.of(context).error1019;
    case 1020:
      return I18n.of(context).error1020;
    case 1021:
      return I18n.of(context).error1021;
    case 1022:
      return I18n.of(context).error1022;
    case 1023:
      return I18n.of(context).error1023;
    case 1024:
      return I18n.of(context).error1024;
    case 1025:
      return I18n.of(context).error1025;
    case 1026:
      return I18n.of(context).error1026;
    case 1027:
      return I18n.of(context).error1027;
    case 1028:
      return I18n.of(context).error1028;
    case 1029:
      return I18n.of(context).error1029;
    case 1030:
      return I18n.of(context).error1030;
    case 1031:
      return I18n.of(context).error1031;
    case 1032:
      return I18n.of(context).error1032;
    case 1033:
      return I18n.of(context).error1033;
    case 1034:
      return I18n.of(context).error1034;
    case 1035:
      return I18n.of(context).error1035;
    case 1036:
      return I18n.of(context).error1036;
    case 1037:
      return I18n.of(context).error1037;
      break;
    default:
      return I18n.of(context).failToast;
  }
}

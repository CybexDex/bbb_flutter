import 'package:bbb_flutter/shared/ui_common.dart';

String translatePostOrderResponseErrorCode({int code, BuildContext context}) {
  switch (code) {
    case 1000:
      return I18n.of(context).error1000;
    case 1001:
      return I18n.of(context).error1001;
    case 1002:
      return I18n.of(context).error1002;
    case 1003:
      return I18n.of(context).error1003;
    case 1004:
      return I18n.of(context).error1004;
    case 1005:
      return I18n.of(context).error1005;
    case 1006:
      return I18n.of(context).error1006;
    case 1007:
      return I18n.of(context).error1007;
    case 1008:
      return I18n.of(context).error1008;
    case 1009:
      return I18n.of(context).error1009;
    case 1010:
      return I18n.of(context).error1010;
    case 1011:
      return I18n.of(context).error1011;
    case 4000:
      return I18n.of(context).error4000;
    case 4001:
      return I18n.of(context).error4001;
    case 4002:
      return I18n.of(context).error4002;
    case 4003:
      return I18n.of(context).error4003;
    case 4004:
      return I18n.of(context).error4004;
    default:
      return I18n.of(context).failToast;
  }
}

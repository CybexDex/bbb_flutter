import 'package:flutter/services.dart';
import 'dart:math';

class TestFormat extends TextInputFormatter {
  TestFormat({this.decimalRange = 3, this.integerRange = 5})
      : assert(decimalRange == null || decimalRange > 0),
        assert(integerRange == null || integerRange > 0);

  final int decimalRange;
  final int integerRange;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // 拿到录入后的字符
    String nValue = newValue.text;
    //当前所选择的文字区域
    TextSelection nSelection = newValue.selection;

    // 先来一波过滤，过滤出数字及小数点
    // 匹配包含数字和小数点的字符
    Pattern p = RegExp(r'(\d+\.?)|(\.?\d+)|(\.?)');
    nValue = p
        .allMatches(nValue)
        .map<String>((Match match) => match.group(0))
        .join();

    // 用匹配完的字符判断
    if (nValue.startsWith('.')) {
      //如果小数点开头，我们给他补个0
      nValue = '0.';
    } else if (nValue.contains('.')) {
      if (nValue.substring(0, nValue.indexOf('.')).length > integerRange) {
        nValue = oldValue.text;
      }
      //来验证小数点位置
      if (nValue.substring(nValue.indexOf('.') + 1).length > decimalRange) {
        nValue = oldValue.text;
      } else {
        if (nValue.split('.').length > 2) {
          //多个小数点，去掉后面的
          List<String> split = nValue.split('.');
          nValue = split[0] + '.' + split[1];
        }
      }
    }
    if (!nValue.contains('.')) {
      if (nValue.length > integerRange) {
        nValue = oldValue.text;
      }
    }

    //使光标定位到最后一个字符后面
    nSelection = newValue.selection.copyWith(
      baseOffset: min(nValue.length, nValue.length + 1),
      extentOffset: min(nValue.length, nValue.length + 1),
    );

    return TextEditingValue(
        text: nValue, selection: nSelection, composing: TextRange.empty);
  }
}

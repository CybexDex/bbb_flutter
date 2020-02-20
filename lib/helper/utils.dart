import 'dart:typed_data';

dynamic convertValueByType(value, Type type, {String stack: ""}) {
  if (value == null) {
    if (type == String) {
      return "";
    } else if (type == int) {
      return 0;
    } else if (type == double) {
      return 0.0;
    } else if (type == bool) {
      return false;
    }
    return null;
  }

  if (value.runtimeType == type) {
    return value;
  }
  var valueS = value.toString();
  if (type == String) {
    return valueS;
  } else if (type == int) {
    return int.tryParse(valueS);
  } else if (type == double) {
    return double.tryParse(valueS);
  } else if (type == bool) {
    valueS = valueS.toLowerCase();
    var intValue = int.tryParse(valueS);
    if (intValue != null) {
      return intValue == 1;
    }
    return valueS == "true";
  }
}

void tryCatch(Function f) {
  try {
    f?.call();
  } catch (e) {}
}

String formatBytesAsHexString(Uint8List bytes) {
  var result = new StringBuffer();
  for (var i = 0; i < bytes.lengthInBytes; i++) {
    var part = bytes[i];
    result.write('${part < 16 ? '0' : ''}${part.toRadixString(16)}');
  }
  return result.toString();
}

String getEllipsisName({String value, int precision}) {
  if (value == null) {
    return null;
  }
  precision = precision ?? 6;
  if (value.length >= precision) {
    return value.substring(0, 3) +
        "***" +
        value.substring(value.length - 2, value.length);
  }

  return value;
}

String getQueryStringFromJson(Map<String, dynamic> json, List<String> keys) {
  String result = "";
  for (String key in keys) {
    result += "$key=${json[key]}&";
  }
  return result.substring(0, result.length - 1);
}

dynamic convertJson(Map<String, dynamic> json) {
  List<dynamic> contracts = [];
  List<String> keys = json["keys"] is List ? [] : null;
  if (keys != null) {
    for (var item in json["keys"]) {
      keys.add(item);
    }
  }
  for (var item in json["data"]) {
    Map<String, dynamic> contract = {};
    for (int i = 0; i < keys.length; i++) {
      contract[keys[i]] = item[i];
    }
    contracts.add(contract);
  }
  var newJson = {"contract": contracts};
  return newJson;
}

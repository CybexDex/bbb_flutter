import 'dart:async';

import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'dart:math' as math;

class ILogInterceptor extends Interceptor {
  ILogInterceptor({
    this.request = true,
    this.requestHeader = true,
    this.requestBody = false,
    this.responseHeader = true,
    this.responseBody = false,
    this.error = true,
    this.logSize = 2048,
  });

  /// Print request [Options]
  bool request;

  /// Print request header [Options.headers]
  bool requestHeader;

  /// Print request data [Options.data]
  bool requestBody;

  /// Print [Response.data]
  bool responseBody;

  /// Print [Response.headers]
  bool responseHeader;

  /// Print error message
  bool error;

  /// Log size per print
  final logSize;

  @override
  FutureOr<dynamic> onRequest(RequestOptions options) {
    locator.get<Logger>().v('*** Request ***');
    printKV('uri', options.uri);

    if (request) {
      printKV('method', options.method);
      printKV('contentType', options.contentType?.toString());
      printKV('responseType', options.responseType?.toString());
      printKV('followRedirects', options.followRedirects);
      printKV('connectTimeout', options.connectTimeout);
      printKV('receiveTimeout', options.receiveTimeout);
      printKV('extra', options.extra);
    }
    if (requestHeader) {
      StringBuffer stringBuffer = new StringBuffer();
      options.headers.forEach((key, v) => stringBuffer.write('\n  $key:$v'));
      printKV('header', stringBuffer.toString());
      stringBuffer.clear();
    }
    if (requestBody) {
      locator.get<Logger>().v("data:");
      printAll(options.data);
    }
    locator.get<Logger>().v("");
  }

  @override
  FutureOr<dynamic> onError(DioError err) {
    if (error) {
      locator.get<Logger>().e('*** DioError ***:');
      locator.get<Logger>().e(err);
      if (err.response != null) {
        _printResponse(err.response);
      }
    }
  }

  @override
  FutureOr<dynamic> onResponse(Response response) {
    locator.get<Logger>().v("*** Response ***");
    _printResponse(response);
  }

  void _printResponse(Response response) {
    printKV('uri', response?.request?.uri);
    if (responseHeader) {
      printKV('statusCode', response.statusCode);
      if (response.isRedirect) printKV('redirect', response.realUri);
      locator.get<Logger>().v("headers:");
      locator
          .get<Logger>()
          .v(" " + response?.headers?.toString()?.replaceAll("\n", "\n "));
    }
    if (responseBody) {
      locator.get<Logger>().v("Response Text:");
      printAll(response.toString());
    }
    locator.get<Logger>().v("");
  }

  printKV(String key, Object v) {
    locator.get<Logger>().v('$key: $v');
  }

  printAll(msg) {
    msg.toString().split("\n").forEach(_printAll);
  }

  _printAll(String msg) {
    int groups = (msg.length / logSize).ceil();
    for (int i = 0; i < groups; ++i) {
      locator.get<Logger>().v((i > 0
              ? '<<Log follows the previous line: '
              : '') +
          msg.substring(
              i * logSize, math.min<int>(i * logSize + logSize, msg.length)));
    }
  }
}

import 'dart:async';

import 'package:dio/dio.dart';

/// [LogInterceptor] is used to print logs during network requests.
/// It's better to add [LogInterceptor] to the tail of the interceptor queue,
/// otherwise the changes made in the interceptor behind A will not be printed out.
/// This is because the execution of interceptors is in the order of addition.
class BBBInterceptor extends Interceptor {
  BBBInterceptor({
    this.request = true,
    this.requestHeader = true,
    this.requestBody = false,
    this.responseHeader = true,
    this.responseBody = false,
    this.error = true,
    this.logPrint = print,
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

  /// Log printer; defaults print log to console.
  /// In flutter, you'd better use debugPrint.
  /// you can also write log in a file, for example:
  ///```dart
  ///  var file=File("./log.txt");
  ///  var sink=file.openWrite();
  ///  dio.interceptors.add(LogInterceptor(logPrint: sink.writeln));
  ///  ...
  ///  await sink.close();
  ///```
  void Function(Object object) logPrint;

  @override
  Future onRequest(RequestOptions options) async {
    if (request) {
      printKV('method', options.method);
      printKV('responseType', options.responseType?.toString());
      printKV('followRedirects', options.followRedirects);
      printKV('connectTimeout', options.connectTimeout);
      printKV('receiveTimeout', options.receiveTimeout);
      printKV('extra', options.extra);
    }
    if (requestHeader) {
      logPrint('headers:');
      options.headers.forEach((key, v) => printKV(' $key', v));
    }
    if (requestBody) {
      logPrint('data:');
      printAll(options.data);
    }
    logPrint('');
  }

  @override
  Future onError(DioError err) async {
    if (error) {
      logPrint('*** DioError ***:');
      logPrint('uri: ${err.request.uri}');
      logPrint('$err');
      if (err.response != null) {
        _printResponse(err.response);
      }
      logPrint('');
    }
    if (err.type == DioErrorType.CONNECT_TIMEOUT) {}
  }

  @override
  Future onResponse(Response response) async {
    _printResponse(response);
  }

  void _printResponse(Response response) {
    if (responseHeader) {
      printKV('statusCode', response.statusCode);
      if (response.isRedirect == true) {
        printKV('redirect', response.realUri);
      }
      if (response.headers != null) {
        logPrint('headers:');
        response.headers.forEach((key, v) => printKV(' $key', v.join(',')));
      }
    }
    if (responseBody) {
      logPrint('Response Text:');
      printAll(response.toString());
    }
    logPrint('');
  }

  void printKV(String key, Object v) {
    logPrint('$key: $v');
  }

  void printAll(msg) {
    msg.toString().split('\n').forEach(logPrint);
  }
}

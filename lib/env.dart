export 'package:bbb_flutter/utils/i18n.dart';
import 'package:bbb_flutter/services/network/BBB/bbb_api.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:stack_trace/stack_trace.dart';

import 'common/types.dart';

class Env {
  static BBBAPI apiClient;
}

Logger log;

void initLogger({@required String package, String tag}) {
  assert(package != null);

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    String codeLocation = "";

    if (buildMode != BuildMode.release) {
      final Frame f = _findCallerFrame(Trace.current());
      codeLocation = ': ${f.member} (${f.library}:${f.line})';
    }
    print('${rec.level.name}/${rec.loggerName}:$codeLocation ${rec.message}');
  });

  log = Logger(tag?.toUpperCase() ?? package.toUpperCase());
}

void printWrapped(String text,
    {Level logLevel = Level.INFO, Object error, StackTrace stackTrace}) {
  final pattern = new RegExp('.{1,800}');
  pattern
      .allMatches(text)
      .forEach((match) => log.log(logLevel, match.group(0), error, stackTrace));
}

Frame _findCallerFrame(Trace trace) {
  bool foundLogging = false;

  for (int i = 0; i < trace.frames.length; ++i) {
    Frame frame = trace.frames[i];

    bool loggingPackage = frame.package == 'logging';
    if (foundLogging && !loggingPackage) {
      return frame;
    }

    foundLogging = loggingPackage;
  }

  return null;
}

BuildMode buildMode = (() {
  if (const bool.fromEnvironment('dart.vm.product')) {
    return BuildMode.release;
  }
  var result = BuildMode.profile;
  assert(() {
    result = BuildMode.debug;
    return true;
  }());
  return result;
}());

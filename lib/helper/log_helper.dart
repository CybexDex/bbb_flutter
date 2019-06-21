import 'package:bbb_flutter/env.dart';
import 'package:bbb_flutter/shared/types.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:stack_trace/stack_trace.dart';

class Log {
  Logger _logger;

  factory Log.outer({@required String package, String tag}) {
    return Log(package: package, tag: tag);
  }

  Log({@required String package, String tag}) {
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

    _logger = Logger(tag?.toUpperCase() ?? package.toUpperCase());
  }

  void printWrapped(String text,
      {Level logLevel = Level.INFO, Object error, StackTrace stackTrace}) {
    final pattern = new RegExp('.{1,800}');
    pattern.allMatches(text).forEach(
        (match) => _logger.log(logLevel, match.group(0), error, stackTrace));
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
}

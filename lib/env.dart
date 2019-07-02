import 'dart:async';

import 'package:bbb_flutter/shared/types.dart';
import 'package:bbb_flutter/shared/ui_common.dart';
import 'package:logging/logging.dart';

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

Future<void> reportError(dynamic error, dynamic stackTrace) async {
  // Print the exception to the console.
  if (buildMode == BuildMode.debug) {
    // Print the full stacktrace in debug mode.
    locator.get<Logger>().shout("Caught error:", error, stackTrace);
    return;
  } else {
    // Send the Exception and Stacktrace to Sentry in Production mode.
    // _sentry.captureException(
    //   exception: error,
    //   stackTrace: stackTrace,
    // );
  }
}

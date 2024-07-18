import 'package:flutter/foundation.dart';

class Logger {
  static bool isProduction = false;
  static const String logTag = 'MyApp';

  static void log(String message) {
    if (!isProduction) {
      debugPrint('$logTag: $message');
    }
  }

  static void logError(String message, {required Object error, StackTrace? stackTrace}) {
    if (!isProduction) {
      debugPrint('$logTag: $message');
      debugPrint('Error: $error');
      if (stackTrace != null) {
        debugPrint('Stack Trace: $stackTrace');
      }
    }
  }
}

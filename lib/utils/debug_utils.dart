import 'dart:developer' as developer;

class DebugUtils {
  static bool get isDebugMode => true;

  static void printInfo(String message) {
    if (isDebugMode) {
      developer.log(
        '💡 INFO: $message',
        name: 'PandaShoes',
        time: DateTime.now(),
      );
    }
  }

  static void printWarning(String message) {
    if (isDebugMode) {
      developer.log(
        '⚠️ WARNING: $message',
        name: 'PandaShoes',
        time: DateTime.now(),
        level: 900,
      );
    }
  }

  static void printError(String message, {Object? error, StackTrace? stackTrace}) {
    if (isDebugMode) {
      developer.log(
        '🔴 ERROR: $message',
        name: 'PandaShoes',
        time: DateTime.now(),
        error: error,
        stackTrace: stackTrace,
        level: 1000,
      );
    }
  }

  static void printApi(
    String url, {
    String method = 'GET',
    Object? data,
    String? response,
  }) {
    if (isDebugMode) {
      final buffer = StringBuffer();
      buffer.writeln('🌐 API Call:');
      buffer.writeln('URL: $url');
      buffer.writeln('Method: $method');

      if (data != null) {
        buffer.writeln('Data: $data');
      }

      if (response != null) {
        buffer.writeln('Response: $response');
      }

      developer.log(
        buffer.toString(),
        name: 'PandaShoes',
        time: DateTime.now(),
      );
    }
  }

  static Future<T> measureAsyncOperation<T>(
    String operationName,
    Future<T> Function() operation,
  ) async {
    if (!isDebugMode) return operation();

    final stopwatch = Stopwatch()..start();
    try {
      final result = await operation();
      stopwatch.stop();
      
      developer.log(
        '⏱️ Operation "$operationName" completed in ${stopwatch.elapsedMilliseconds}ms',
        name: 'PandaShoes',
        time: DateTime.now(),
      );
      
      return result;
    } catch (e) {
      stopwatch.stop();
      developer.log(
        '⏱️ Operation "$operationName" failed after ${stopwatch.elapsedMilliseconds}ms',
        name: 'PandaShoes',
        time: DateTime.now(),
        error: e,
      );
      rethrow;
    }
  }
}

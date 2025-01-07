import 'dart:developer' as developer;

class DebugUtils {
  static bool get isDebugMode => true;

  static void printApi(
    String url, {
    required String method,
    Map<String, dynamic>? data,
    String? response,
    int? statusCode,
  }) {
    if (!isDebugMode) return;

    final buffer = StringBuffer()
      ..writeln('🌐 API Call:')
      ..writeln('URL: $url')
      ..writeln('Method: $method');

    if (data != null) {
      buffer.writeln('Data: $data');
    }

    if (statusCode != null) {
      buffer.writeln('Status Code: $statusCode');
    }

    if (response != null) {
      if (response.length > 1000) {
        buffer.writeln('Response: ${response.substring(0, 1000)}... (truncated)');
      } else {
        buffer.writeln('Response: $response');
      }
    }

    developer.log(buffer.toString());
  }

  static void printInfo(String message) {
    if (!isDebugMode) return;
    developer.log('ℹ️ $message');
  }

  static void printError(String message, {Object? error, StackTrace? stackTrace}) {
    if (!isDebugMode) return;
    developer.log(
      '❌ $message',
      error: error,
      stackTrace: stackTrace,
    );
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
      printInfo('$operationName completed in ${stopwatch.elapsedMilliseconds}ms');
      return result;
    } catch (e) {
      stopwatch.stop();
      printError(
        '$operationName failed after ${stopwatch.elapsedMilliseconds}ms',
        error: e,
      );
      rethrow;
    }
  }
}

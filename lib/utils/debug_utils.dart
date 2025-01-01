import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class DebugUtils {
  static bool get isDebugMode {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }

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
        level: 900, // Warning
      );
    }
  }

  static void printError(String message, {dynamic error, StackTrace? stackTrace}) {
    if (isDebugMode) {
      developer.log(
        '🔴 ERROR: $message',
        name: 'PandaShoes',
        time: DateTime.now(),
        error: error,
        stackTrace: stackTrace,
        level: 1000, // Error
      );
    }
  }

  static void printApi(String endpoint, {String? method, dynamic data, dynamic response}) {
    if (isDebugMode) {
      final buffer = StringBuffer();
      buffer.writeln('📡 API Call:');
      buffer.writeln('Endpoint: $endpoint');
      if (method != null) buffer.writeln('Method: $method');
      if (data != null) buffer.writeln('Data: $data');
      if (response != null) buffer.writeln('Response: $response');

      developer.log(
        buffer.toString(),
        name: 'PandaShoes-API',
        time: DateTime.now(),
      );
    }
  }

  static void printState(String widget, String action, {dynamic data}) {
    if (isDebugMode) {
      final buffer = StringBuffer();
      buffer.writeln('🔄 State Change:');
      buffer.writeln('Widget: $widget');
      buffer.writeln('Action: $action');
      if (data != null) buffer.writeln('Data: $data');

      developer.log(
        buffer.toString(),
        name: 'PandaShoes-State',
        time: DateTime.now(),
      );
    }
  }

  static void startPerformanceTrace(String operation) {
    if (isDebugMode) {
      final timeline = developer.Timeline.startSync(
        operation,
        arguments: {'timestamp': DateTime.now().toIso8601String()},
      );
      timeline.finish();
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
      printInfo('$operationName completed in ${stopwatch.elapsedMilliseconds}ms');
      return result;
    } catch (e, stackTrace) {
      stopwatch.stop();
      printError(
        '$operationName failed after ${stopwatch.elapsedMilliseconds}ms',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  static void logMemoryUsage() {
    if (isDebugMode) {
      final memory = ProcessInfo.currentRss;
      final memoryMB = memory / (1024 * 1024);
      printInfo('Current Memory Usage: ${memoryMB.toStringAsFixed(2)} MB');
    }
  }
}

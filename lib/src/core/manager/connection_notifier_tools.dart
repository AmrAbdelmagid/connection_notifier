import 'package:connection_notifier/src/core/manager/connection_notifier_manager.dart'
    show ConnectionNotifierManager;
import 'package:flutter/foundation.dart' show immutable;
import 'package:rxdart/transformers.dart';

/// A class that provides useful tools for connection management. To be used
/// properly, [initialize] method must be called before using it's data.

@immutable
class ConnectionNotifierTools {
  const ConnectionNotifierTools._();

  static late ConnectionNotifierManager _connectionNotifierManager;

  /// Initializes the [ConnectionNotifierManager]. Must be called before using
  /// other class data, typically on app initialization.
  static Future<void> initialize() async {
    _connectionNotifierManager = ConnectionNotifierManager.instance;
    await _connectionNotifierManager.initialize();
  }

  /// A boolean that has the latest update about the connection status.
  static bool get isConnected => _connectionNotifierManager.isConnected!;

  /// A broadcast stream that emits on every change in the connection status.
  static Stream<bool> get onStatusChange =>
      _connectionNotifierManager.connection.switchMap<bool>(
        (isConnected) => Stream.value(isConnected!).asBroadcastStream(),
      );
}

library connection_notifier_manager;

import 'dart:async' show Future, Stream, StreamSubscription;

import 'package:connection_notifier/src/core/internal/connection_handler_impl.dart'
    show ConnectionNotifierHandlerImpl;

import 'package:connection_notifier/src/core/public/connection_notifier_internet_connection_status.dart'
    show ConnectionNotifierInternetConnectionStatus;
import 'package:connection_notifier/src/core/public/connection_handler.dart';

import 'package:rxdart/subjects.dart' show BehaviorSubject;

class ConnectionNotifierManager {
  ConnectionNotifierManager._sharedInstance();

  bool? get isConnected {
    if (_connectionStatus.value == null) return null;
    return _connectionStatus.value ==
        ConnectionNotifierInternetConnectionStatus.connected;
  }

  static final ConnectionNotifierManager _shared =
      ConnectionNotifierManager._sharedInstance();

  static ConnectionNotifierManager get instance => _shared;

  Stream<bool?> get connection => _connectionStatus.stream.map((status) {
        if (status == null) return null;
        if (status == ConnectionNotifierInternetConnectionStatus.disconnected) {
          return false;
        }
        return true;
      }).asBroadcastStream();

  Stream<ConnectionNotifierInternetConnectionStatus?> get connectionStatus =>
      _connectionStatus.stream.asBroadcastStream();

  /// Internal status stream source. Starts as `null` until first resolution.
  final BehaviorSubject<ConnectionNotifierInternetConnectionStatus?>
      _connectionStatus = BehaviorSubject()..add(null);

  /// Arms a one-shot "Back Online" notification after a disconnect.
  bool showConnectionNotification = false;

  /// Optional injected connection handler from the consumer.
  ConnectionHandler? _connectionHandler;

  /// Active handler used by the manager (injected or default implementation).
  ConnectionHandler get connectionHandler =>
      _connectionHandler ?? const ConnectionNotifierHandlerImpl();

  /// Last known connectivity status.
  ConnectionNotifierInternetConnectionStatus? _currentStatus;

  /// Monotonic token to invalidate stale delayed resume operations.
  int _resumeToken = 0;

  /// Tracks whether the app is currently in background lifecycle states.
  bool _isAppInBackground = false;

  /// Subscription to handler connectivity updates.
  StreamSubscription<ConnectionNotifierInternetConnectionStatus>? _subscription;

  void _subscribeToConnectionChanges() {
    if (_subscription != null) return;

    _subscription = connectionHandler.onStatusChange.listen(
      (status) {
        if (_currentStatus == status) {
          return;
        }
        _currentStatus = status;
        _connectionStatus.add(status);
        if (status == ConnectionNotifierInternetConnectionStatus.disconnected) {
          showConnectionNotification = true;
        }
      },
    );
  }

  /// Initializes connectivity monitoring.
  ///
  /// Pass [connectionHandler] to override the default implementation.
  /// Returns the current internet connectivity after initial resolution.
  Future<bool> initialize({ConnectionHandler? connectionHandler}) async {
    if (connectionHandler != null &&
        !identical(_connectionHandler, connectionHandler)) {
      _connectionHandler = connectionHandler;

      if (_subscription != null) {
        _subscription?.cancel();
        _subscription = null;
      }
    }

    if (_subscription != null) {
      return _resolveCurrentConnection();
    }

    _subscribeToConnectionChanges();

    return _resolveCurrentConnection();
  }

  /// Resolves the current connectivity using cached status or a fresh check.
  Future<bool> _resolveCurrentConnection() async {
    if (_currentStatus != null) {
      return _currentStatus ==
          ConnectionNotifierInternetConnectionStatus.connected;
    }

    final hasInternetAccess = await connectionHandler.hasInternetAccess;
    setConnectionStatus(hasInternetAccess);
    return hasInternetAccess;
  }

  /// Pushes a connectivity state into the stream if it changed.
  void setConnectionStatus(bool isConnected) {
    final status = isConnected
        ? ConnectionNotifierInternetConnectionStatus.connected
        : ConnectionNotifierInternetConnectionStatus.disconnected;

    if (_currentStatus == status) {
      return;
    }

    _currentStatus = status;
    _connectionStatus.add(status);

    if (!isConnected) {
      showConnectionNotification = true;
    }
  }

  /// Consumes and resets the one-shot connected notification flag.
  bool consumeConnectedNotification() {
    if (!showConnectionNotification) {
      return false;
    }

    showConnectionNotification = false;
    return true;
  }

  /// Called when the app goes to background.
  /// Cancels the subscription entirely so no buffered events accumulate.
  void pause() {
    if (_isAppInBackground) return;

    _isAppInBackground = true;
    _subscription?.cancel();
    _subscription = null;
    _resumeToken++;
  }

  /// Called when the app returns to foreground.
  /// Waits 3 seconds to let the OS settle network state, then re-subscribes.
  Future<void> resume() async {
    _isAppInBackground = false;
    final token = ++_resumeToken;

    await Future.delayed(const Duration(seconds: 3));

    // If pause() was called again during the delay, abort.
    if (_isAppInBackground || token != _resumeToken) return;

    _subscribeToConnectionChanges();

    final hasInternetAccess = await connectionHandler.hasInternetAccess;
    if (_isAppInBackground || token != _resumeToken) return;
    setConnectionStatus(hasInternetAccess);
  }
}

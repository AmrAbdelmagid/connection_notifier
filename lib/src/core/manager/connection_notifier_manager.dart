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

  final BehaviorSubject<ConnectionNotifierInternetConnectionStatus?>
      _connectionStatus = BehaviorSubject()..add(null);

  bool showConnectionNotification = false;

  ConnectionHandler? _connectionHandler;

  ConnectionHandler get connectionHandler =>
      _connectionHandler ?? const ConnectionNotifierHandlerImpl();

  bool _pauseListening = false;

  ConnectionNotifierInternetConnectionStatus? _currentStatus;

  StreamSubscription<ConnectionNotifierInternetConnectionStatus>? _subscription;

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

    _subscription = this.connectionHandler.onStatusChange.listen(
      (status) {
        final connected =
            status == ConnectionNotifierInternetConnectionStatus.connected;
        _currentStatus = status;
        if (_pauseListening) {
          return;
        } else {
          _wasPreviousStatus = _currentStatus;
          _connectionStatus.add(status);
          if (!connected) {
            showConnectionNotification = true;
          }
        }
      },
    );

    return _resolveCurrentConnection();
  }

  Future<bool> _resolveCurrentConnection() async {
    if (_currentStatus != null) {
      return _currentStatus ==
          ConnectionNotifierInternetConnectionStatus.connected;
    }

    final hasInternetAccess = await connectionHandler.hasInternetAccess;
    setConnectionStatus(hasInternetAccess);
    return hasInternetAccess;
  }

  ConnectionNotifierInternetConnectionStatus? _wasPreviousStatus;

  void setConnectionStatus(bool isConnected) {
    final status = isConnected
        ? ConnectionNotifierInternetConnectionStatus.connected
        : ConnectionNotifierInternetConnectionStatus.disconnected;

    _currentStatus = status;
    _wasPreviousStatus = status;
    _connectionStatus.add(status);

    if (!isConnected) {
      showConnectionNotification = true;
    }
  }

  void _pauseListeningToChanges(bool paused) {
    if (paused) {
      _subscription?.pause();
    } else {
      _subscription?.resume();
    }

    if (_pauseListening == paused) {
      return;
    } else {
      _pauseListening = paused;
    }

    if (!paused && _currentStatus != null) {
      final wasDisconnected = _currentStatus ==
          ConnectionNotifierInternetConnectionStatus.disconnected;
      final wasConnected = _wasPreviousStatus ==
          ConnectionNotifierInternetConnectionStatus.connected;

      if (wasDisconnected) {
        _connectionStatus.add(_currentStatus);
      } else if (!wasConnected) {
        _connectionStatus.add(_currentStatus);
        _wasPreviousStatus = _currentStatus;
      }
    }
  }

  void resume() {
    _pauseListeningToChanges(false);
  }

  void pause() {
    _pauseListeningToChanges(true);
  }
}

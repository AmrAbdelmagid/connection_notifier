library connection_notifier_manager;

import 'dart:async' show Completer, Future, Stream, StreamSubscription;

import 'package:connection_notifier/src/core/internal/connection_handler.dart'
    show ConnectionHandler;

import 'package:connection_notifier/src/core/internal/connection_notifier_internet_connection_status.dart'
    show ConnectionNotifierInternetConnectionStatus;

import 'package:rxdart/subjects.dart' show BehaviorSubject;

class ConnectionNotifierManager {
  ConnectionNotifierManager._sharedInstance() {
    if (!_initializationCompleter.isCompleted) {
      initialize();
    }
  }

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

  final Completer<bool> _initializationCompleter = Completer();

  bool showConnectionNotification = false;

  bool _pauseListening = false;

  ConnectionNotifierInternetConnectionStatus? _currentStatus;

  StreamSubscription<ConnectionNotifierInternetConnectionStatus>? _subscription;

  Future<bool> initialize() async {
    _subscription = ConnectionHandler.onStatusChange.listen(
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
        if (!_initializationCompleter.isCompleted) {
          _initializationCompleter.complete(connected);
        }
      },
    );
    return _initializationCompleter.future;
  }

  ConnectionNotifierInternetConnectionStatus? _wasPreviousStatus;

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

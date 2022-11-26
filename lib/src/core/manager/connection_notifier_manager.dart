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

  bool? get isConnected => _connection.value;

  static final ConnectionNotifierManager _shared =
      ConnectionNotifierManager._sharedInstance();

  static ConnectionNotifierManager get instance => _shared;

  Stream<bool?> get connection => _connection.stream.asBroadcastStream();

  final BehaviorSubject<bool?> _connection = BehaviorSubject()..add(null);

  final Completer<bool> _initializationCompleter = Completer();

  bool showConnectionNotification = false;

  bool _pauseListening = false;

  bool _connected = false;

  StreamSubscription<ConnectionNotifierInternetConnectionStatus>? _subscription;

  Future<bool> initialize() async {
    _subscription = ConnectionHandler.onStatusChange.listen(
      (status) {
        final connected =
            status == ConnectionNotifierInternetConnectionStatus.connected;
        _connected = connected;
        if (_pauseListening) {
          return;
        } else {
          if (connected) {
            _wasPreviouslyConnected = connected;
            _connection.add(true);
          } else {
            showConnectionNotification = true;
            _wasPreviouslyConnected = connected;
            _connection.add(false);
          }
        }
        if (!_initializationCompleter.isCompleted) {
          _initializationCompleter.complete(connected);
        }
      },
    );
    return _initializationCompleter.future;
  }

  var _wasPreviouslyConnected = false;

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

    if (!paused && !_connected) {
      _connection.add(false);
    } else if (!paused && _connected && !_wasPreviouslyConnected) {
      _connection.add(true);
      _wasPreviouslyConnected = true;
    }
  }

  void resume() {
    _pauseListeningToChanges(false);
  }

  void pause() {
    _pauseListeningToChanges(true);
  }
}

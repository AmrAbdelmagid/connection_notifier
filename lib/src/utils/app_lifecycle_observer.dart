import 'package:rxdart/subjects.dart' show BehaviorSubject;

import 'package:flutter/material.dart'
    show AppLifecycleState, WidgetsBinding, WidgetsBindingObserver;

class AppLifecycleObserver with WidgetsBindingObserver {
  AppLifecycleState? _state;

  late BehaviorSubject<AppLifecycleState> _appLifecycleStateController;

  AppLifecycleState? get state => _state;

  Stream<AppLifecycleState> get stream => _appLifecycleStateController.stream;

  AppLifecycleObserver() {
    WidgetsBinding.instance.addObserver(this);
    _appLifecycleStateController = BehaviorSubject<AppLifecycleState>();
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _appLifecycleStateController.close();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _state = state;

    _appLifecycleStateController.sink.add(state);
  }
}

library connection_notifier_manager;

import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:connection_notifier/src/widget/connection_notifier_position.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

part 'package:connection_notifier/src/widget/status_widget.dart';
part 'connection_notifier_manager_state.dart';
part 'package:connection_notifier/src/widget/connection_notifier.dart';
part 'package:connection_notifier/src/widget/connection_notifier_toggler.dart';
part 'package:connection_notifier/src/widget/manager_provider_widget.dart';

class ConnectionNotifierManager extends Cubit<_ConnectionNotifierManagerState> {
  ConnectionNotifierManager() : super(_ManagerInitial());

  static bool? isConnected(context) =>
      BlocProvider.of<ConnectionNotifierManager>(context)._hasInternet;

  late StreamSubscription _subscription;

  bool? _hasInternet;
  // ignore: unused_field
  bool _showInternetNotification = false;

  void _check() {
    _subscription =
        InternetConnectionChecker().onStatusChange.listen((status) async {
      final _hasInternet = status == InternetConnectionStatus.connected;
      this._hasInternet = _hasInternet;
      if (this._hasInternet!) {
        emit(_InternetAvailableState());
      } else {
        emit(_InternetNotAvailableState());
        _showInternetNotification = true;
      }
    });
  }

  @override
  close() async {
    _subscription.cancel();
    super.close();
  }
}

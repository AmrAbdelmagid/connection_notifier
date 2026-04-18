import 'package:connection_notifier/src/core/public/connection_handler.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    show InternetConnection, InternetStatus;
import 'package:rxdart/rxdart.dart';

import '../public/connection_notifier_internet_connection_status.dart'
    show ConnectionNotifierInternetConnectionStatus;

@immutable
class ConnectionNotifierHandlerImpl implements ConnectionHandler {
  const ConnectionNotifierHandlerImpl();

  @override
  Stream<ConnectionNotifierInternetConnectionStatus> get onStatusChange =>
      InternetConnection().onStatusChange.switchMap(
        (InternetStatus value) {
          switch (value) {
            case InternetStatus.connected:
              return Stream.value(
                ConnectionNotifierInternetConnectionStatus.connected,
              );
            case InternetStatus.disconnected:
              return Stream.value(
                ConnectionNotifierInternetConnectionStatus.disconnected,
              );
          }
        },
      );

  @override
  Future<bool> get hasInternetAccess => InternetConnection().hasInternetAccess;
}

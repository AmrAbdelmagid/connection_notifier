import 'package:flutter/foundation.dart' show immutable;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    show InternetConnection, InternetStatus;
import 'package:rxdart/rxdart.dart';

import 'connection_notifier_internet_connection_status.dart'
    show ConnectionNotifierInternetConnectionStatus;

@immutable
class ConnectionHandler {
  static Stream<ConnectionNotifierInternetConnectionStatus>
      get onStatusChange => InternetConnection().onStatusChange.switchMap(
            (InternetStatus value) {
              switch (value) {
                case InternetStatus.connected:
                  return Stream.value(
                      ConnectionNotifierInternetConnectionStatus.connected);
                case InternetStatus.disconnected:
                  return Stream.value(
                      ConnectionNotifierInternetConnectionStatus.disconnected);
              }
            },
          );
}

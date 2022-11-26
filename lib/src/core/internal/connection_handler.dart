import 'package:flutter/foundation.dart' show immutable;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    show InternetConnectionChecker, InternetConnectionStatus;
import 'package:rxdart/rxdart.dart';

import 'connection_notifier_internet_connection_status.dart'
    show ConnectionNotifierInternetConnectionStatus;

@immutable
class ConnectionHandler {
  static Stream<ConnectionNotifierInternetConnectionStatus>
      get onStatusChange =>
          InternetConnectionChecker().onStatusChange.switchMap(
            (value) {
              switch (value) {
                case InternetConnectionStatus.connected:
                  return Stream.value(
                      ConnectionNotifierInternetConnectionStatus.connected);
                case InternetConnectionStatus.disconnected:
                  return Stream.value(
                      ConnectionNotifierInternetConnectionStatus.disconnected);
              }
            },
          );
}

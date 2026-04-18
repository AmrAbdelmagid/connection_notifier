import 'package:connection_notifier/src/core/public/connection_notifier_internet_connection_status.dart';

abstract class ConnectionHandler {
  Stream<ConnectionNotifierInternetConnectionStatus> get onStatusChange;

  Future<bool> get hasInternetAccess;
}

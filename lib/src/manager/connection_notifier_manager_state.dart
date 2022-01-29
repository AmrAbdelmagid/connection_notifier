part of connection_notifier_manager;

@immutable
abstract class _ConnectionNotifierManagerState {}

class _ManagerInitial extends _ConnectionNotifierManagerState {}

class _InternetAvailableState extends _ConnectionNotifierManagerState {}

class _InternetNotAvailableState extends _ConnectionNotifierManagerState {}

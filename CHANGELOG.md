## 2.0.1
- Fix linter warning of missing case clause for hidden case in AppLifecycleState.
## 2.0.0

- Introducing the new `LocalConnectionNotifier` for showing local connection notification per specific screen.
- A breaking change: Move connection notification options into a separate object named `ConnectionNotificationOptions`.
## 1.0.1
- Updated readme.

## 1.0.0

- Added more options to the `ConnectionNotifier` widget for enhanced customization.
- Removed dependencies on `bloc`, `flutter_bloc`, and `oktoast` packages.
- Introduced new tools for connection management.
- The `ConnectionNotifierManager.isConnected(context)` method has been deprecated. Use `ConnectionNotifierTools.isConnected` instead. Refer to the documentation for more information.

## 0.0.1

- Initial release.
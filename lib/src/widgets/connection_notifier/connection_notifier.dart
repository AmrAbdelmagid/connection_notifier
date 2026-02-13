library connection_notifier_manager;

import 'dart:async' show StreamSubscription;

import 'package:connection_notifier/src/core/manager/connection_notifier_manager.dart';
import 'package:connection_notifier/src/core/internal/connection_notifier_internet_connection_status.dart';
import 'package:connection_notifier/connection_notifier.dart'
    show ConnectionNotificationOptions;
import 'package:flutter/material.dart'
    show
        AppLifecycleState,
        BuildContext,
        Key,
        OverlayState,
        State,
        StatefulWidget,
        Widget;
import 'package:connection_notifier/src/utils/app_lifecycle_observer.dart';
import 'package:connection_notifier/src/widgets/connection_status_overlay/connection_status_overlay.dart';

part 'connection_notifier_state.dart';

/// Shows a global connection notification when connection status changes.
///
/// This widget listens to connection status changes and displays overlay
/// notifications accordingly. It can be used in two ways:
///
/// 1. Wrapped with [ConnectionNotifierWrapper] (recommended for Navigator 2.0):
/// ```dart
/// ConnectionNotifierWrapper(
///   child: MaterialApp(
///     home: ConnectionNotifier(
///       connectionNotificationOptions: ConnectionNotificationOptions(...),
///       child: MyHomePage(),
///     ),
///   ),
/// )
/// ```
///
/// 2. With [overlayState] parameter (for advanced use cases):
/// ```dart
/// MaterialApp(
///   navigatorKey: navigatorKey,
///   home: ConnectionNotifier(
///     overlayState: navigatorKey.currentState?.overlay,
///     connectionNotificationOptions: ConnectionNotificationOptions(...),
///     child: MyHomePage(),
///   ),
/// )
/// ```
class ConnectionNotifier extends StatefulWidget {
  const ConnectionNotifier({
    Key? key,
    required this.child,
    this.connectionNotificationOptions = const ConnectionNotificationOptions(),
    this.overlayState,
  }) : super(key: key);

  /// Child widget to display.
  final Widget child;

  /// Configuration options for connection notifications.
  final ConnectionNotificationOptions connectionNotificationOptions;

  /// Optional overlay state for displaying notifications.
  /// If not provided, the overlay will be found from the widget tree.
  final OverlayState? overlayState;

  @override
  State<ConnectionNotifier> createState() => _ConnectionNotifierState();
}

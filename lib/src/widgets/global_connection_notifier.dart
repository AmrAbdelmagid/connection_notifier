import 'dart:async' show StreamSubscription;
import 'package:flutter/material.dart';
import 'package:connection_notifier/connection_notifier.dart'
    show ConnectionNotificationOptions;
import 'package:connection_notifier/src/core/manager/connection_notifier_manager.dart';
import 'package:connection_notifier/src/core/internal/connection_notifier_internet_connection_status.dart';
import 'package:connection_notifier/src/utils/app_lifecycle_observer.dart';
import 'package:connection_notifier/src/widgets/connection_status_overlay/connection_status_overlay.dart';

/// Wraps your MaterialApp to enable connection notifications throughout your app.
///
/// This is the **ONLY** widget you need to use! Simply wrap your MaterialApp
/// with this widget and connection notifications will work everywhere.
///
/// Works with ALL navigation types:
/// - Navigator 1.0 (classic navigation)
/// - Navigator 2.0 (declarative navigation)
/// - GoRouter, AutoRoute, Beamer, etc.
/// - Web applications
///
/// Example:
/// ```dart
/// GlobalConnectionNotifier(
///   connectionNotificationOptions: ConnectionNotificationOptions(
///     alignment: Alignment.topCenter,
///     // ... other options
///   ),
///   child: MaterialApp(
///     home: MyHomePage(),
///   ),
/// )
/// ```
class GlobalConnectionNotifier extends StatefulWidget {
  const GlobalConnectionNotifier({
    Key? key,
    required this.child,
    this.connectionNotificationOptions = const ConnectionNotificationOptions(),
  }) : super(key: key);

  /// The child widget, typically [MaterialApp] or [CupertinoApp]
  final Widget child;

  /// Configuration options for connection notifications
  final ConnectionNotificationOptions connectionNotificationOptions;

  @override
  State<GlobalConnectionNotifier> createState() =>
      _GlobalConnectionNotifierState();
}

class _GlobalConnectionNotifierState extends State<GlobalConnectionNotifier> {
  final AppLifecycleObserver appLifecycleObserver = AppLifecycleObserver();
  final ConnectionNotifierManager connectionNotifierManager =
      ConnectionNotifierManager.instance;
  final connectionStatusOverlay = ConnectionStatusOverlay.instance;

  late final StreamSubscription<ConnectionNotifierInternetConnectionStatus?>
      _connectionSubscription;

  @override
  void initState() {
    super.initState();

    if (widget.connectionNotificationOptions
        .pauseConnectionListenerWhenAppInBackground) {
      appLifecycleObserver.stream.listen(
        (state) {
          switch (state) {
            case AppLifecycleState.resumed:
              connectionNotifierManager.resume();
              break;
            case AppLifecycleState.inactive:
            case AppLifecycleState.paused:
            case AppLifecycleState.detached:
            case AppLifecycleState.hidden:
              connectionNotifierManager.pause();
          }
        },
      );
    }

    // Set up connection listener once in initState
    _connectionSubscription = connectionNotifierManager.connectionStatus.listen(
      (status) => _connectionListener(status),
    );
  }

  /// Finds the OverlayState by traversing child elements to locate Navigator
  OverlayState? _findOverlayState() {
    NavigatorState? navigator;

    void visitor(Element element) {
      if (navigator != null) return;

      if (element.widget is Navigator) {
        navigator = (element as StatefulElement).state as NavigatorState?;
      } else {
        element.visitChildElements(visitor);
      }
    }

    context.visitChildElements(visitor);
    return navigator?.overlay;
  }

  Future<void> _showOverlay({
    required bool isConnected,
  }) async {
    if (!mounted) return;

    final overlayState = _findOverlayState();

    if (overlayState == null) {
      debugPrint(
        'GlobalConnectionNotifier: Could not find Navigator overlay. '
        'Make sure GlobalConnectionNotifier wraps MaterialApp/CupertinoApp.',
      );
      return;
    }

    await connectionStatusOverlay.show(
      context: context,
      overlayState: overlayState,
      isConnected: isConnected,
      alignment: widget.connectionNotificationOptions.alignment,
      height: widget.connectionNotificationOptions.height,
      width: widget.connectionNotificationOptions.width,
      connectedBackgroundColor:
          widget.connectionNotificationOptions.connectedBackgroundColor,
      disconnectedBackgroundColor:
          widget.connectionNotificationOptions.disconnectedBackgroundColor,
      connectedContent: widget.connectionNotificationOptions.connectedContent,
      disconnectedContent:
          widget.connectionNotificationOptions.disconnectedContent,
      connectedText: widget.connectionNotificationOptions.connectedText,
      disconnectedText: widget.connectionNotificationOptions.disconnectedText,
      overlayAnimationType:
          widget.connectionNotificationOptions.overlayAnimationType,
      shouldAlwaysPullContentDownOnTopAlignment: widget
          .connectionNotificationOptions
          .shouldAlwaysPullContentDownOnTopAlignment,
      animationCurve: widget.connectionNotificationOptions.animationCurve,
      animationDuration: widget.connectionNotificationOptions.animationDuration,
      hasIndicationIcon: widget.connectionNotificationOptions.hasIndicationIcon,
      connectedTextStyle:
          widget.connectionNotificationOptions.connectedTextStyle,
      disconnectedTextStyle:
          widget.connectionNotificationOptions.disconnectedTextStyle,
      connectedIcon: widget.connectionNotificationOptions.connectedIcon,
      disconnectedIcon: widget.connectionNotificationOptions.disconnectedIcon,
      textAndIconSeparationWith:
          widget.connectionNotificationOptions.textAndIconSeparationWidth,
      iconBoxSideLength: widget.connectionNotificationOptions.iconBoxSideLength,
      connectedConnectionNotification:
          widget.connectionNotificationOptions.connectedConnectionNotification,
      disconnectedConnectionNotification: widget
          .connectionNotificationOptions.disconnectedConnectionNotification,
      borderRadius: widget.connectionNotificationOptions.borderRadius,
      connectedDuration: widget.connectionNotificationOptions.connectedDuration,
      disconnectedDuration:
          widget.connectionNotificationOptions.disconnectedDuration,
    );
  }

  Future<void> _connectionListener(
      ConnectionNotifierInternetConnectionStatus? status) async {
    if (status == null || !mounted) return;

    switch (status) {
      case ConnectionNotifierInternetConnectionStatus.connected:
        if (connectionNotifierManager.showConnectionNotification) {
          await _showOverlay(isConnected: true);
        }
        break;
      case ConnectionNotifierInternetConnectionStatus.disconnected:
        _showOverlay(isConnected: false);
        break;
    }
  }

  @override
  void dispose() {
    _connectionSubscription.cancel();
    appLifecycleObserver.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

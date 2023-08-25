library connection_notifier_manager;

import 'package:connection_notifier/src/core/manager/connection_notifier_manager.dart';
import 'package:connection_notifier/connection_notifier.dart'
    show ConnectionNotificationOptions;
import 'package:flutter/material.dart'
    show
        AppLifecycleState,
        BuildContext,
        Builder,
        Key,
        Locale,
        LocalizationsDelegate,
        MaterialApp,
        State,
        StatefulWidget,
        Widget;
import 'package:connection_notifier/src/utils/app_lifecycle_observer.dart';
import 'package:connection_notifier/src/widgets/connection_status_overlay/connection_status_overlay.dart';

part 'connection_notifier_state.dart';

/// Shows a global connection notification when connection status changes, typically
/// used as a parent to [MaterialApp].

class ConnectionNotifier extends StatefulWidget {
  const ConnectionNotifier({
    Key? key,
    required this.child,
    this.connectionNotificationOptions = const ConnectionNotificationOptions(),
    this.locale,
    this.supportedLocales,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
  }) : super(key: key);

  /// Child widget, typically [MaterialApp] or [CupertinoApp].
  final Widget child;

  final ConnectionNotificationOptions connectionNotificationOptions;

  /// Mirror of MaterialApp [locale] property.
  final Locale? locale;

  /// Mirror of MaterialApp [supportedLocales] property.
  final Iterable<Locale>? supportedLocales;

  /// Mirror of MaterialApp [localizationsDelegates] property.
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  /// Mirror of MaterialApp [localeListResolutionCallback] property.
  final Locale? Function(List<Locale>?, Iterable<Locale>)?
      localeListResolutionCallback;

  /// Mirror of MaterialApp [localeResolutionCallback] property.
  final Locale? Function(Locale?, Iterable<Locale>)? localeResolutionCallback;

  @override
  State<ConnectionNotifier> createState() => _ConnectionNotifierState();
}

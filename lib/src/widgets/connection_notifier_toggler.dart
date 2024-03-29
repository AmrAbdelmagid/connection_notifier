import 'package:connection_notifier/src/core/manager/connection_notifier_manager.dart'
    show ConnectionNotifierManager;
import 'package:flutter/material.dart'
    show
        BuildContext,
        Center,
        CircularProgressIndicator,
        Key,
        StatelessWidget,
        StreamBuilder,
        Widget;

class ConnectionNotifierToggler extends StatelessWidget {
  const ConnectionNotifierToggler({
    Key? key,
    this.loading,
    required this.connected,
    required this.disconnected,
    this.onConnectionStatusChanged,
  }) : super(key: key);

  /// Loading widget, typically this will appear once in the initialization
  /// and will not be noticeable in most cases.
  final Widget? loading;

  /// Connected widget.
  final Widget connected;

  /// Disconnected widget.
  final Widget disconnected;

  /// A callback that is triggered with every change in the connection state
  /// if it is not [null], and provides the current state.
  final void Function(bool? connected)? onConnectionStatusChanged;

  @override
  Widget build(BuildContext context) {
    final ConnectionNotifierManager connectionNotifierManager =
        ConnectionNotifierManager.instance;
    return StreamBuilder<bool?>(
      stream: connectionNotifierManager.connection,
      builder: (context, snapshot) {
        if (onConnectionStatusChanged != null) {
          onConnectionStatusChanged!(connectionNotifierManager.isConnected);
        }
        if (snapshot.hasData) {
          return connectionNotifierManager.isConnected == null
              ? loading ??
                  const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
              : connectionNotifierManager.isConnected!
                  ? connected
                  : disconnected;
        } else {
          return loading ??
              const Center(
                child: CircularProgressIndicator.adaptive(),
              );
        }
      },
    );
  }
}

part of connection_notifier_manager;

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
    return BlocBuilder<ConnectionNotifierManager,
        _ConnectionNotifierManagerState>(
      builder: (context, state) {
        if (onConnectionStatusChanged != null) {
          onConnectionStatusChanged!(
              ConnectionNotifierManager.isConnected(context));
        }

        return ConnectionNotifierManager.isConnected(context) == null
            ? loading ??
                const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
            : ConnectionNotifierManager.isConnected(context)!
                ? connected
                : disconnected;
      },
    );
  }
}

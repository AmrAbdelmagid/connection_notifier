part of connection_notifier_manager;

class _ConnectionNotifierState extends State<ConnectionNotifier> {
  final AppLifecycleObserver appLifecycleObserver = AppLifecycleObserver();
  final ConnectionNotifierManager connectionNotifierManager =
      ConnectionNotifierManager.instance;

  final connectionStatusOverlay = ConnectionStatusOverlay.instance;

  StreamSubscription<ConnectionNotifierInternetConnectionStatus?>?
      _connectionSubscription;

  void _subscribeConnectionListener() {
    _connectionSubscription ??=
        connectionNotifierManager.connectionStatus.listen(
      (status) => _connectionListener(status),
    );
  }

  void _unsubscribeConnectionListener() {
    _connectionSubscription?.cancel();
    _connectionSubscription = null;
  }

  @override
  void initState() {
    super.initState();

    _subscribeConnectionListener();

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
  }

  Future<void> _showOverlay({
    required bool isConnected,
  }) async {
    if (!mounted) return;

    await connectionStatusOverlay.show(
      context: context,
      overlayState: widget.overlayState,
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
    _unsubscribeConnectionListener();
    appLifecycleObserver.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

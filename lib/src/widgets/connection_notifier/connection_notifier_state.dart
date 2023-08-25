part of connection_notifier_manager;

class _ConnectionNotifierState extends State<ConnectionNotifier> {
  final AppLifecycleObserver appLifecycleObserver = AppLifecycleObserver();
  final ConnectionNotifierManager connectionNotifierManager =
      ConnectionNotifierManager.instance;

  final connectionStatusOverlay = ConnectionStatusOverlay.instance;

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
              connectionNotifierManager.pause();
          }
        },
      );
    }
  }

  Future<void> _showOverlay({
    required BuildContext context,
    required bool isConnected,
  }) async {
    await connectionStatusOverlay.show(
      context: context,
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
      BuildContext context, bool? isConnected) async {
    if (isConnected == null) return;

    if (isConnected) {
      if (connectionNotifierManager.showConnectionNotification) {
        await _showOverlay(context: context, isConnected: true);
      }
    } else {
      _showOverlay(context: context, isConnected: false);
    }
  }

  @override
  void dispose() {
    appLifecycleObserver.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: widget.locale,
      supportedLocales:
          widget.supportedLocales ?? const <Locale>[Locale('en', 'US')],
      localizationsDelegates: widget.localizationsDelegates,
      localeListResolutionCallback: widget.localeListResolutionCallback,
      localeResolutionCallback: widget.localeResolutionCallback,
      home: Builder(
        builder: (context) {
          connectionNotifierManager.connection.listen(
            (isConnected) => _connectionListener(context, isConnected),
          );

          return widget.child;
        },
      ),
    );
  }
}

part of connection_notifier_manager;

class _ConnectionNotifierState extends State<ConnectionNotifier> {
  final AppLifecycleObserver appLifecycleObserver = AppLifecycleObserver();
  final ConnectionNotifierManager connectionNotifierManager =
      ConnectionNotifierManager.instance;

  final connectionStatusOverlay = ConnectionStatusOverlay.instance;

  @override
  void initState() {
    super.initState();

    if (widget.pauseConnectionListenerWhenAppInBackground) {
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
      alignment: widget.alignment,
      height: widget.height,
      width: widget.width,
      connectedBackgroundColor: widget.connectedBackgroundColor,
      disconnectedBackgroundColor: widget.disconnectedBackgroundColor,
      connectedContent: widget.connectedContent,
      disconnectedContent: widget.disconnectedContent,
      connectedText: widget.connectedText,
      disconnectedText: widget.disconnectedText,
      overlayAnimationType: widget.overlayAnimationType,
      shouldAlwaysPullContentDownOnTopAlignment:
          widget.shouldAlwaysPullContentDownOnTopAlignment,
      animationCurve: widget.animationCurve,
      animationDuration: widget.animationDuration,
      hasIndicationIcon: widget.hasIndicationIcon,
      connectedTextStyle: widget.connectedTextStyle,
      disconnectedTextStyle: widget.disconnectedTextStyle,
      connectedIcon: widget.connectedIcon,
      disconnectedIcon: widget.disconnectedIcon,
      textAndIconSeparationWith: widget.textAndIconSeparationWidth,
      iconBoxSideLength: widget.iconBoxSideLength,
      connectedConnectionNotification: widget.connectedConnectionNotification,
      disconnectedConnectionNotification:
          widget.disconnectedConnectionNotification,
      borderRadius: widget.borderRadius,
      connectedDuration: widget.connectedDuration,
      disconnectedDuration: widget.disconnectedDuration,
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

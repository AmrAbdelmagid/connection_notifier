part of connection_notifier_manager;

class ConnectionNotifier extends StatelessWidget {
  const ConnectionNotifier(
      {Key? key,
      required this.child,
      this.locale,
      this.supportedLocales,
      this.localizationsDelegates,
      this.disconnectedDuration,
      this.connectedDuration,
      this.connectedBackgroundColor,
      this.disconnectedBackgroundColor,
      this.connectedContent,
      this.disconnectedContent,
      this.height,
      this.width,
      this.animationCurve})
      : super(key: key);

  /// Child widget, typically [MaterialApp] or [CupertinoApp].
  final Widget child;

  /// Content of the connected state, typically a [Row] widget.
  final Widget? connectedContent;

  /// Content of the disconnected state, typically a [Row] widget.
  final Widget? disconnectedContent;

  /// Height of the bar, default is [MediaQuery.of(context).padding.top * 2].
  final double? height;

  /// Width of the bar, default is [double.infinity].
  final double? width;

  /// Locale of the app.
  final Locale? locale;

  /// Supported locales of the app.
  final Iterable<Locale>? supportedLocales;

  /// Localizations Delegates of the app.
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  /// Disconnected duration, default is 1 Day.
  final Duration? disconnectedDuration;

  /// Connected duration, default is 2 seconds.
  final Duration? connectedDuration;

  /// Connected background color, default is [Colors.green].
  final Color? connectedBackgroundColor;

  /// disconnected background color, default is [Colors.red].
  final Color? disconnectedBackgroundColor;

  /// Animation curve of the bar
  final Curve? animationCurve;

  @override
  Widget build(BuildContext context) {
    return _ConnectionNotifierProvider(
      child: OKToast(
        child: MaterialApp(
          locale: locale,
          debugShowCheckedModeBanner: false,
          supportedLocales:
              supportedLocales ?? const <Locale>[Locale('en', 'US')],
          localizationsDelegates: localizationsDelegates,
          home: BlocListener<ConnectionNotifierManager,
              _ConnectionNotifierManagerState>(
            listener: (context, state) {
              if (state is _InternetNotAvailableState) {
                showToastWidget(
                    _StatusWidget(
                      hasInternet: false,
                      context: context,
                      disconnectedBackgroundColor: disconnectedBackgroundColor,
                      disconnectedContent: disconnectedContent,
                      height: height,
                      width: width,
                    ),
                    position: ConnectionNotifierPosition.top,
                    dismissOtherToast: true,
                    animationCurve: animationCurve,
                    duration: disconnectedDuration ?? const Duration(days: 1));
              }
              if (state is _InternetAvailableState &&
                  BlocProvider.of<ConnectionNotifierManager>(context)
                      ._showInternetNotification) {
                showToastWidget(
                    _StatusWidget(
                      hasInternet: true,
                      context: context,
                      connectedBackgroundColor: connectedBackgroundColor,
                      connectedContent: connectedContent,
                    ),
                    position: ConnectionNotifierPosition.top,
                    dismissOtherToast: true,
                    animationCurve: animationCurve,
                    duration: connectedDuration ?? const Duration(seconds: 2));
              }
            },
            child: child,
          ),
        ),
      ),
    );
  }
}

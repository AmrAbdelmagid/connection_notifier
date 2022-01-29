part of connection_notifier_manager;

class _StatusWidget extends StatelessWidget {
  final bool hasInternet;
  final BuildContext context;
  final Color? connectedBackgroundColor;
  final Color? disconnectedBackgroundColor;
  final Widget? connectedContent;
  final Widget? disconnectedContent;
  final double? height;
  final double? width;
  const _StatusWidget({
    Key? key,
    required this.hasInternet,
    required this.context,
    this.connectedBackgroundColor,
    this.disconnectedBackgroundColor,
    this.connectedContent,
    this.disconnectedContent,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return Stack(
      children: [
        Container(
          height: height ?? MediaQuery.of(context).padding.top * 2,
          width: width ?? double.infinity,
          color: hasInternet
              ? connectedBackgroundColor ?? Colors.green
              : disconnectedBackgroundColor ?? Colors.red,
          alignment: Alignment.bottomCenter,
        ),
        Positioned(
          bottom: 0,
          child: SizedBox(
            height: MediaQuery.of(context).padding.top,
            width: MediaQuery.of(context).size.width,
            child: Directionality(
              textDirection: Directionality.of(context),
              child: hasInternet
                  ? connectedContent ??
                      _DefaultContent(hasInternet: hasInternet)
                  : disconnectedContent ??
                      _DefaultContent(hasInternet: hasInternet),
            ),
          ),
        ),
      ],
    );
  }
}

class _DefaultContent extends StatelessWidget {
  const _DefaultContent({
    Key? key,
    required this.hasInternet,
  }) : super(key: key);

  final bool hasInternet;

  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          hasInternet ? 'Back Online' : 'Retrying',
        ),
        const SizedBox(width: 10),
        SizedBox(
          height: 10,
          width: 10,
          child: hasInternet
              ? const Icon(
                  Icons.check,
                  size: 12,
                  color: Colors.white,
                )
              : isIOS
                  ? CupertinoTheme(
                      data: CupertinoTheme.of(context)
                          .copyWith(brightness: Brightness.dark),
                      child: const CupertinoActivityIndicator(),
                    )
                  : const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2.0,
                    ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart'
    show
        AlwaysStoppedAnimation,
        Brightness,
        BuildContext,
        Center,
        CircularProgressIndicator,
        Color,
        Colors,
        Icon,
        Icons,
        Key,
        MainAxisAlignment,
        Row,
        SizedBox,
        StatelessWidget,
        TargetPlatform,
        Text,
        TextStyle,
        Theme,
        Widget;
import 'package:flutter/cupertino.dart'
    show CupertinoActivityIndicator, CupertinoTheme;

class DefaultConnectionNotificationContent extends StatelessWidget {
  const DefaultConnectionNotificationContent({
    Key? key,
    required this.isConnected,
    required this.connectedText,
    required this.disconnectedText,
    required this.hasIndicationIcon,
    required this.connectedTextStyle,
    required this.disconnectedTextStyle,
    required this.connectedIcon,
    required this.disconnectedIcon,
    required this.textAndIconSeparationWith,
    required this.iconBoxSideLength,
  }) : super(key: key);

  final bool isConnected;
  final String? connectedText;
  final String? disconnectedText;
  final bool hasIndicationIcon;
  final TextStyle? connectedTextStyle;
  final TextStyle? disconnectedTextStyle;
  final Icon? connectedIcon;
  final Icon? disconnectedIcon;
  final double? textAndIconSeparationWith;
  final double? iconBoxSideLength;

  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isConnected
                ? (connectedText ?? 'Back Online')
                : (disconnectedText ?? 'Retrying'),
            style: (isConnected ? connectedTextStyle : disconnectedTextStyle) ??
                const TextStyle(color: Colors.white),
          ),
          if (hasIndicationIcon)
            SizedBox(width: textAndIconSeparationWith ?? 10),
          if (hasIndicationIcon)
            SizedBox(
              height: iconBoxSideLength ?? 10,
              width: iconBoxSideLength ?? 10,
              child: isConnected
                  ? connectedIcon ??
                      const Icon(
                        Icons.check,
                        size: 12,
                        color: Colors.white,
                      )
                  : disconnectedIcon ??
                      (isIOS
                          ? CupertinoTheme(
                              data: CupertinoTheme.of(context)
                                  .copyWith(brightness: Brightness.dark),
                              child: const CupertinoActivityIndicator(),
                            )
                          : const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 2.0,
                            )),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart'
    show
        AlwaysStoppedAnimation,
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
        Text,
        TextStyle,
        Widget;

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
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
            ),
        ],
      ),
    );
  }
}

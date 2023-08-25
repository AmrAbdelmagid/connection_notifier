import 'package:connection_notifier/connection_notifier.dart';
import 'package:flutter/material.dart';

/// Configuration options of the connection notification.
@immutable
class ConnectionNotificationOptions {
  /// Alignment of the connection notification, default is [AlignmentDirectional.topCenter].
  final AlignmentGeometry alignment;

  /// To pause listening to changes while app in background, default is [false].
  final bool pauseConnectionListenerWhenAppInBackground;

  /// Height of the connection notification, default is twice top padding.
  final double? height;

  /// Width of the connection notification, default is [double.infinity].
  final double? width;

  /// Border radius of the connection notification.
  final BorderRadiusGeometry? borderRadius;

  /// Background color of the connection notification in connected
  /// state, default is [Colors.green].
  final Color? connectedBackgroundColor;

  /// Background color of the connection notification in connected
  /// state, default is [Colors.red].
  final Color? disconnectedBackgroundColor;

  /// Duration of the connection notification in connected
  /// state before it's auto dismissing, default is 2 seconds.
  final Duration? connectedDuration;

  /// Duration of the connection notification in disconnected
  /// state before it's auto dismissing, default is infinity.
  final Duration? disconnectedDuration;

  /// Overlay animation type of the connection notification, default is [OverlayAnimationType.fadeAndSlide].
  final OverlayAnimationType overlayAnimationType;

  /// Animation curve of the connection notification, default is [Curves.fastOutSlowIn].
  final Curve? animationCurve;

  /// Animation duration of the connection notification, default is 300 milliseconds.
  final Duration? animationDuration;

  /// Content of connection notification in connected state. if this is given,
  /// it will override all the specific parameters for the default content in
  /// connected state, typically a [Row] widget.
  final Widget? connectedContent;

  /// Content of connection notification in disconnected state. if this is given,
  /// it will override all the specific parameters for the default content in
  /// disconnected state, typically a [Row] widget.
  final Widget? disconnectedContent;

  /// If the content of the connection notification should be pulled
  /// down in case of top alignment and [height] is grater than twice of
  /// top padding only, to test it visually just set a [height] that is
  /// bigger than twice of top padding (300 for example) and toggle it
  /// between [true] and [false] to see it's effect, default is [true].
  final bool shouldAlwaysPullContentDownOnTopAlignment;

  /// If the default content has an indication icon, default is [true].
  final bool hasIndicationIcon;

  /// Distance between text and icon in default content, default is 10.
  final double? textAndIconSeparationWidth;

  /// Text of the default content of the connection notification in
  /// connected state, default is ['Back Online'].
  final String? connectedText;

  /// Text of the default content of the connection notification in
  /// disconnected state, default is ['Retrying'].
  final String? disconnectedText;

  /// Text style of the default content of the connection notification in
  /// connected state.
  final TextStyle? connectedTextStyle;

  /// Text style of the default content of the connection notification in
  /// disconnected state.
  final TextStyle? disconnectedTextStyle;

  /// Icon of the default content of the connection notification in
  /// connected state, default is icon widget with [Icons.check].
  final Icon? connectedIcon;

  /// Icon of the default content of the connection notification in
  /// disconnected state, default is circular progress indicator.
  final Icon? disconnectedIcon;

  /// Length of each side (height and width) of the [SizedBox] that wraps
  /// the [Icon] of the default content of the connection notification,
  /// default is 10.
  final double? iconBoxSideLength;

  /// This is useful if you want to override default connection notification
  /// with a custom widget in connected state and it will use the alignment
  /// and animation.
  final Widget? connectedConnectionNotification;

  /// This is useful if you want to override default connection notification
  /// with a custom widget in disconnected state and it will use the alignment
  /// and animation.
  final Widget? disconnectedConnectionNotification;

  const ConnectionNotificationOptions({
    this.alignment = AlignmentDirectional.topCenter,
    this.pauseConnectionListenerWhenAppInBackground = false,
    this.height,
    this.width,
    this.borderRadius,
    this.connectedBackgroundColor,
    this.disconnectedBackgroundColor,
    this.connectedDuration,
    this.disconnectedDuration,
    this.overlayAnimationType = OverlayAnimationType.fadeAndSlide,
    this.animationCurve,
    this.animationDuration,
    this.connectedContent,
    this.disconnectedContent,
    this.shouldAlwaysPullContentDownOnTopAlignment = true,
    this.hasIndicationIcon = true,
    this.textAndIconSeparationWidth,
    this.connectedText,
    this.disconnectedText,
    this.connectedTextStyle,
    this.disconnectedTextStyle,
    this.connectedIcon,
    this.disconnectedIcon,
    this.iconBoxSideLength,
    this.connectedConnectionNotification,
    this.disconnectedConnectionNotification,
  });
}

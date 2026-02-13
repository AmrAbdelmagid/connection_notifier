import 'package:connection_notifier/connection_notifier.dart'
    show OverlayAnimationType;
import 'package:flutter/material.dart'
    show
        AlignmentGeometry,
        AnimationController,
        BorderRadiusGeometry,
        BuildContext,
        Color,
        Curve,
        Icon,
        Overlay,
        OverlayEntry,
        OverlayState,
        TextStyle,
        Widget;

import 'connection_status_overlay_controller.dart'
    show ConnectionStatusOverlayController;
import '../connection_status_view.dart' show ConnectionStatusView;

class ConnectionStatusOverlay {
  ConnectionStatusOverlay._sharedInstance();
  static final ConnectionStatusOverlay _shared =
      ConnectionStatusOverlay._sharedInstance();
  static ConnectionStatusOverlay get instance => _shared;

  ConnectionStatusOverlayController? _controller;

  AnimationController? _animationController;

  Future<void> show({
    required BuildContext context,
    OverlayState? overlayState,
    required bool isConnected,
    required AlignmentGeometry alignment,
    required OverlayAnimationType overlayAnimationType,
    required double? height,
    required double? width,
    required Color? connectedBackgroundColor,
    required Color? disconnectedBackgroundColor,
    required Widget? connectedContent,
    required Widget? disconnectedContent,
    required Widget? connectedConnectionNotification,
    required Widget? disconnectedConnectionNotification,
    required String? connectedText,
    required String? disconnectedText,
    required bool shouldAlwaysPullContentDownOnTopAlignment,
    required Curve? animationCurve,
    required Duration? animationDuration,
    required bool hasIndicationIcon,
    required TextStyle? connectedTextStyle,
    required TextStyle? disconnectedTextStyle,
    required Icon? connectedIcon,
    required Icon? disconnectedIcon,
    required double? textAndIconSeparationWith,
    required double? iconBoxSideLength,
    required BorderRadiusGeometry? borderRadius,
    required Duration? disconnectedDuration,
    required Duration? connectedDuration,
  }) async {
    if (_animationController != null) {
      await _animationController!.reverse();
    }
    _hide();
    if (context.mounted) {
      _controller = _showOverlay(
        context: context,
        overlayState: overlayState,
        isConnected: isConnected,
        alignment: alignment,
        height: height,
        width: width,
        connectedBackgroundColor: connectedBackgroundColor,
        disconnectedBackgroundColor: disconnectedBackgroundColor,
        connectedContent: connectedContent,
        disconnectedContent: disconnectedContent,
        connectedText: connectedText,
        disconnectedText: disconnectedText,
        overlayAnimationType: overlayAnimationType,
        shouldAlwaysPullContentDownOnTopAlignment:
            shouldAlwaysPullContentDownOnTopAlignment,
        animationCurve: animationCurve,
        animationDuration: animationDuration,
        hasIndicationIcon: hasIndicationIcon,
        connectedTextStyle: connectedTextStyle,
        disconnectedTextStyle: disconnectedTextStyle,
        connectedIcon: connectedIcon,
        disconnectedIcon: disconnectedIcon,
        textAndIconSeparationWith: textAndIconSeparationWith,
        iconBoxSideLength: iconBoxSideLength,
        connectedConnectionNotification: connectedConnectionNotification,
        disconnectedConnectionNotification: disconnectedConnectionNotification,
        borderRadius: borderRadius,
        connectedDuration: connectedDuration,
        disconnectedDuration: disconnectedDuration,
      );
    }
  }

  void _hide() {
    _controller?.close();
    _animationController = null;
    _controller = null;
  }

  ConnectionStatusOverlayController _showOverlay({
    required BuildContext context,
    OverlayState? overlayState,
    required bool isConnected,
    required AlignmentGeometry alignment,
    required double? height,
    required double? width,
    required Color? connectedBackgroundColor,
    required Color? disconnectedBackgroundColor,
    required Widget? connectedContent,
    required Widget? disconnectedContent,
    required Widget? connectedConnectionNotification,
    required Widget? disconnectedConnectionNotification,
    required String? connectedText,
    required String? disconnectedText,
    required OverlayAnimationType overlayAnimationType,
    required bool shouldAlwaysPullContentDownOnTopAlignment,
    required Curve? animationCurve,
    required Duration? animationDuration,
    required bool hasIndicationIcon,
    required TextStyle? connectedTextStyle,
    required TextStyle? disconnectedTextStyle,
    required Icon? connectedIcon,
    required Icon? disconnectedIcon,
    required double? textAndIconSeparationWith,
    required double? iconBoxSideLength,
    required BorderRadiusGeometry? borderRadius,
    required Duration? disconnectedDuration,
    required Duration? connectedDuration,
  }) {
    final overlay = OverlayEntry(
      builder: (_) => ConnectionStatusView(
        isConnected: isConnected,
        alignment: alignment,
        height: height,
        width: width,
        connectedBackgroundColor: connectedBackgroundColor,
        disconnectedBackgroundColor: disconnectedBackgroundColor,
        connectedContent: connectedContent,
        disconnectedContent: disconnectedContent,
        connectedConnectionNotification: connectedConnectionNotification,
        disconnectedConnectionNotification: disconnectedConnectionNotification,
        connectedText: connectedText,
        disconnectedText: disconnectedText,
        overlayAnimationType: overlayAnimationType,
        shouldAlwaysPullContentDownOnTopAlignment:
            shouldAlwaysPullContentDownOnTopAlignment,
        animationCurve: animationCurve,
        animationDuration: animationDuration,
        hasIndicationIcon: hasIndicationIcon,
        connectedTextStyle: connectedTextStyle,
        disconnectedTextStyle: disconnectedTextStyle,
        connectedIcon: connectedIcon,
        disconnectedIcon: disconnectedIcon,
        textAndIconSeparationWith: textAndIconSeparationWith,
        iconBoxSideLength: iconBoxSideLength,
        borderRadius: borderRadius,
        disconnectedDuration: disconnectedDuration,
        connectedDuration: connectedDuration,
        hide: _hide,
        onInitialization: (animationController) =>
            _animationController = animationController,
      ),
    );

    // Use provided overlayState or get it from context with rootOverlay: true
    final state = overlayState ?? Overlay.of(context, rootOverlay: true);
    state.insert(overlay);

    return ConnectionStatusOverlayController(
      close: () {
        overlay.remove();
        return true;
      },
    );
  }
}

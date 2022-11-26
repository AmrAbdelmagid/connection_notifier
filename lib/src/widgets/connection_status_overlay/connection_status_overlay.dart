import 'package:connection_notifier/connection_notifier.dart'
    show OverlayAnimationType;
import 'package:connection_notifier/src/utils/alignment_helper.dart'
    show AlignmentHelper;
import 'package:connection_notifier/src/widgets/default_connection_notification_content.dart'
    show DefaultConnectionNotificationContent;
import 'package:flutter/material.dart'
    show
        Align,
        AlignmentGeometry,
        AnimationController,
        BorderRadiusGeometry,
        BoxDecoration,
        BuildContext,
        Color,
        Colors,
        Column,
        Container,
        Curve,
        Directionality,
        Icon,
        Material,
        MaterialType,
        MediaQueryData,
        Overlay,
        OverlayEntry,
        SizedBox,
        TextStyle,
        Widget,
        WidgetsBinding;

import 'connection_status_overlay_controller.dart'
    show ConnectionStatusOverlayController;
import 'overlay_animation.dart' show OverlayAnimation;

class ConnectionStatusOverlay {
  ConnectionStatusOverlay._sharedInstance();
  static final ConnectionStatusOverlay _shared =
      ConnectionStatusOverlay._sharedInstance();
  static ConnectionStatusOverlay get instance => _shared;

  ConnectionStatusOverlayController? _controller;

  AnimationController? _animationController;

  Future<void> show({
    required BuildContext context,
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
    _controller = _showOverlay(
      context: context,
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

  void _hide() {
    _controller?.close();
    _animationController = null;
    _controller = null;
  }

  ConnectionStatusOverlayController _showOverlay({
    required BuildContext context,
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
      builder: (context) {
        final topPaddingHeight =
            (MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                    .padding
                    .top *
                2);
        final heightHalf = (height ?? topPaddingHeight) / 2;
        final AlignmentHelper alignmentHelper = AlignmentHelper(alignment);
        final bool _shouldPullContentDownOnTopAlignment =
            !(height != null && height > (topPaddingHeight * 2)) ||
                shouldAlwaysPullContentDownOnTopAlignment;

        return Material(
          type: MaterialType.transparency,
          child: Align(
            alignment: alignment,
            child: Directionality(
              textDirection: Directionality.of(context),
              child: OverlayAnimation(
                onInitialization: (animationController) =>
                    _animationController = animationController,
                isConnected: isConnected,
                overlayAnimationType: overlayAnimationType,
                alignment: alignment,
                animationDuration: animationDuration,
                animationCurve: animationCurve,
                hideOverlay: _hide,
                connectedDuration: connectedDuration,
                disconnectedDuration: disconnectedDuration,
                child: (isConnected
                        ? connectedConnectionNotification
                        : disconnectedConnectionNotification) ??
                    Container(
                      height: height ?? topPaddingHeight,
                      width: width ?? double.infinity,
                      decoration: BoxDecoration(
                        color: isConnected
                            ? (connectedBackgroundColor ?? Colors.green)
                            : (disconnectedBackgroundColor ?? Colors.red),
                        borderRadius: borderRadius,
                      ),
                      child: Column(
                        children: [
                          if (alignmentHelper.isTopAlignment &&
                              _shouldPullContentDownOnTopAlignment)
                            SizedBox(height: heightHalf),
                          SizedBox(
                            height: alignmentHelper.isTopAlignment &&
                                    _shouldPullContentDownOnTopAlignment
                                ? heightHalf
                                : heightHalf * 2,
                            child: (isConnected
                                    ? connectedContent
                                    : disconnectedContent) ??
                                DefaultConnectionNotificationContent(
                                  isConnected: isConnected,
                                  connectedText: connectedText,
                                  disconnectedText: disconnectedText,
                                  hasIndicationIcon: hasIndicationIcon,
                                  connectedTextStyle: connectedTextStyle,
                                  disconnectedTextStyle: disconnectedTextStyle,
                                  connectedIcon: connectedIcon,
                                  disconnectedIcon: disconnectedIcon,
                                  textAndIconSeparationWith:
                                      textAndIconSeparationWith,
                                  iconBoxSideLength: iconBoxSideLength,
                                ),
                          ),
                        ],
                      ),
                    ),
              ),
            ),
          ),
        );
      },
    );

    final state = Overlay.of(context);
    state?.insert(overlay);

    return ConnectionStatusOverlayController(
      close: () {
        overlay.remove();
        return true;
      },
    );
  }
}

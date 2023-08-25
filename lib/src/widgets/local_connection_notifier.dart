import 'package:connection_notifier/connection_notifier.dart'
    show ConnectionNotificationOptions, ConnectionNotifierToggler;
import 'package:connection_notifier/src/widgets/connection_status_view.dart'
    show ConnectionStatusView;
import 'package:flutter/material.dart'
    show
        BuildContext,
        Key,
        Scaffold,
        SizedBox,
        Stack,
        State,
        StatefulWidget,
        UniqueKey,
        ValueListenableBuilder,
        ValueNotifier,
        Widget;
import 'package:flutter/scheduler.dart' show SchedulerBinding;

/// Shows a local connection notification when the connection status changes
/// for the screen it wraps.
class LocalConnectionNotifier extends StatefulWidget {
  const LocalConnectionNotifier({
    Key? key,
    required this.child,
    this.connectionNotificationOptions = const ConnectionNotificationOptions(),
  }) : super(key: key);

  /// Child widget, typically [Scaffold] or [CupertinoPageScaffold].
  final Widget child;

  final ConnectionNotificationOptions connectionNotificationOptions;

  @override
  State<LocalConnectionNotifier> createState() =>
      _LocalConnectionNotifierState();
}

class _LocalConnectionNotifierState extends State<LocalConnectionNotifier> {
  late final ValueNotifier<bool?> _connectionNotifier;
  late final ValueNotifier<bool> _connectionLostAtLeastOnceNotifier;
  @override
  void initState() {
    super.initState();
    _connectionNotifier = ValueNotifier(null);
    _connectionLostAtLeastOnceNotifier = ValueNotifier(false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        ValueListenableBuilder(
          valueListenable: _connectionLostAtLeastOnceNotifier,
          builder: (context, bool isConnectionLostAtLeastOnce, _) {
            return ValueListenableBuilder(
              valueListenable: _connectionNotifier,
              builder: (context, _, __) {
                return ConnectionNotifierToggler(
                  onConnectionStatusChanged: (connected) {
                    if (connected == null) {
                      return;
                    }

                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      _connectionNotifier.value = connected;
                    });

                    if ((_connectionLostAtLeastOnceNotifier.value == true) ||
                        connected == true) {
                      return;
                    }

                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      _connectionLostAtLeastOnceNotifier.value = true;
                    });
                  },
                  connected: isConnectionLostAtLeastOnce
                      ? ConnectionStatusView(
                          key: UniqueKey(),
                          isConnected: true,
                          alignment:
                              widget.connectionNotificationOptions.alignment,
                          height: widget.connectionNotificationOptions.height,
                          width: widget.connectionNotificationOptions.width,
                          connectedBackgroundColor: widget
                              .connectionNotificationOptions
                              .connectedBackgroundColor,
                          disconnectedBackgroundColor: widget
                              .connectionNotificationOptions
                              .disconnectedBackgroundColor,
                          connectedContent: widget
                              .connectionNotificationOptions.connectedContent,
                          disconnectedContent: widget
                              .connectionNotificationOptions
                              .disconnectedContent,
                          connectedConnectionNotification: widget
                              .connectionNotificationOptions
                              .connectedConnectionNotification,
                          disconnectedConnectionNotification: widget
                              .connectionNotificationOptions
                              .disconnectedConnectionNotification,
                          connectedText: widget
                              .connectionNotificationOptions.connectedText,
                          disconnectedText: widget
                              .connectionNotificationOptions.disconnectedText,
                          overlayAnimationType: widget
                              .connectionNotificationOptions
                              .overlayAnimationType,
                          shouldAlwaysPullContentDownOnTopAlignment: widget
                              .connectionNotificationOptions
                              .shouldAlwaysPullContentDownOnTopAlignment,
                          animationCurve: widget
                              .connectionNotificationOptions.animationCurve,
                          animationDuration: widget
                              .connectionNotificationOptions.animationDuration,
                          hasIndicationIcon: widget
                              .connectionNotificationOptions.hasIndicationIcon,
                          connectedTextStyle: widget
                              .connectionNotificationOptions.connectedTextStyle,
                          disconnectedTextStyle: widget
                              .connectionNotificationOptions
                              .disconnectedTextStyle,
                          connectedIcon: widget
                              .connectionNotificationOptions.connectedIcon,
                          disconnectedIcon: widget
                              .connectionNotificationOptions.disconnectedIcon,
                          textAndIconSeparationWith: widget
                              .connectionNotificationOptions
                              .textAndIconSeparationWidth,
                          iconBoxSideLength: widget
                              .connectionNotificationOptions.iconBoxSideLength,
                          borderRadius:
                              widget.connectionNotificationOptions.borderRadius,
                          disconnectedDuration: widget
                              .connectionNotificationOptions
                              .disconnectedDuration,
                          connectedDuration: widget
                              .connectionNotificationOptions.connectedDuration,
                          hide: () {},
                          onInitialization: (animationController) {},
                        )
                      : const SizedBox(),
                  disconnected: ConnectionStatusView(
                    key: UniqueKey(),
                    isConnected: false,
                    alignment: widget.connectionNotificationOptions.alignment,
                    height: widget.connectionNotificationOptions.height,
                    width: widget.connectionNotificationOptions.width,
                    connectedBackgroundColor: widget
                        .connectionNotificationOptions.connectedBackgroundColor,
                    disconnectedBackgroundColor: widget
                        .connectionNotificationOptions
                        .disconnectedBackgroundColor,
                    connectedContent:
                        widget.connectionNotificationOptions.connectedContent,
                    disconnectedContent: widget
                        .connectionNotificationOptions.disconnectedContent,
                    connectedConnectionNotification: widget
                        .connectionNotificationOptions
                        .connectedConnectionNotification,
                    disconnectedConnectionNotification: widget
                        .connectionNotificationOptions
                        .disconnectedConnectionNotification,
                    connectedText:
                        widget.connectionNotificationOptions.connectedText,
                    disconnectedText:
                        widget.connectionNotificationOptions.disconnectedText,
                    overlayAnimationType: widget
                        .connectionNotificationOptions.overlayAnimationType,
                    shouldAlwaysPullContentDownOnTopAlignment: widget
                        .connectionNotificationOptions
                        .shouldAlwaysPullContentDownOnTopAlignment,
                    animationCurve:
                        widget.connectionNotificationOptions.animationCurve,
                    animationDuration:
                        widget.connectionNotificationOptions.animationDuration,
                    hasIndicationIcon:
                        widget.connectionNotificationOptions.hasIndicationIcon,
                    connectedTextStyle:
                        widget.connectionNotificationOptions.connectedTextStyle,
                    disconnectedTextStyle: widget
                        .connectionNotificationOptions.disconnectedTextStyle,
                    connectedIcon:
                        widget.connectionNotificationOptions.connectedIcon,
                    disconnectedIcon:
                        widget.connectionNotificationOptions.disconnectedIcon,
                    textAndIconSeparationWith: widget
                        .connectionNotificationOptions
                        .textAndIconSeparationWidth,
                    iconBoxSideLength:
                        widget.connectionNotificationOptions.iconBoxSideLength,
                    borderRadius:
                        widget.connectionNotificationOptions.borderRadius,
                    disconnectedDuration: widget
                        .connectionNotificationOptions.disconnectedDuration,
                    connectedDuration:
                        widget.connectionNotificationOptions.connectedDuration,
                    hide: () {},
                    onInitialization: (animationController) {},
                  ),
                  loading: const SizedBox(),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

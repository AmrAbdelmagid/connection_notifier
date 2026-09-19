import 'package:connection_notifier/src/utils/alignment_helper.dart'
    show AlignmentHelper;
import 'package:connection_notifier/src/widgets/connection_status_overlay/overlay_animation_type.dart'
    show OverlayAnimationType;
import 'package:flutter/material.dart'
    show
        AlignmentGeometry,
        Animation,
        AnimationController,
        AnimationStatus,
        BuildContext,
        Curve,
        CurvedAnimation,
        Curves,
        FadeTransition,
        Key,
        Offset,
        SingleTickerProviderStateMixin,
        SlideTransition,
        State,
        StatefulWidget,
        Tween,
        VoidCallback,
        Widget;

class OverlayAnimation extends StatefulWidget {
  const OverlayAnimation({
    Key? key,
    required this.child,
    required this.alignment,
    required this.overlayAnimationType,
    this.animationDuration,
    this.animationCurve,
    required this.isConnected,
    required this.hideOverlay,
    required this.disconnectedDuration,
    required this.connectedDuration,
    required this.onInitialization,
  }) : super(key: key);

  final Widget child;

  final bool isConnected;

  final AlignmentGeometry alignment;

  final OverlayAnimationType overlayAnimationType;

  final Duration? animationDuration;

  final Curve? animationCurve;

  final VoidCallback hideOverlay;

  final Duration? disconnectedDuration;

  final Duration? connectedDuration;

  final void Function(AnimationController) onInitialization;

  @override
  State<OverlayAnimation> createState() => _OverlayAnimationState();
}

class _OverlayAnimationState extends State<OverlayAnimation>
    with SingleTickerProviderStateMixin {
  /// Null when [OverlayAnimationType.none] is used, in which case no ticker is
  /// ever created. Nullable rather than `late` so that [dispose] never has to
  /// re-derive whether a controller exists from the current widget.
  AnimationController? _controller;

  /// Null for [OverlayAnimationType.fade] and [OverlayAnimationType.none].
  Animation<Offset>? _tweenSlideAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.overlayAnimationType != OverlayAnimationType.none) {
      final animationDuration =
          widget.animationDuration ?? const Duration(milliseconds: 300);
      final animationCurve = widget.animationCurve ?? Curves.fastOutSlowIn;
      final AlignmentHelper alignmentHelper = AlignmentHelper(widget.alignment);
      final double dySlideAnimationStartingPoint =
          alignmentHelper.isTopAlignment
              ? -1.0
              : alignmentHelper.isBottomAlignment
                  ? 1.0
                  : 0.0;

      final controller = AnimationController(
        vsync: this,
        duration: animationDuration,
        reverseDuration: animationDuration,
      );
      _controller = controller;

      controller.forward();

      widget.onInitialization(controller);

      if (widget.overlayAnimationType != OverlayAnimationType.fade) {
        _tweenSlideAnimation = Tween<Offset>(
          begin: Offset(
            0.0,
            dySlideAnimationStartingPoint,
          ),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: animationCurve,
            reverseCurve: animationCurve,
          ),
        );
      }

      controller.addStatusListener(_onAnimationStatusChanged);
    }
  }

  /// Auto-hides the notification once it has been on screen long enough.
  ///
  /// Every `await` here is a point at which this [State] can be disposed — the
  /// user navigates away, or a newer connection status replaces this overlay —
  /// so [mounted] is re-checked after each one. Without that, `reverse()` runs
  /// against a disposed ticker and `hideOverlay()` closes whichever overlay
  /// replaced this one.
  Future<void> _onAnimationStatusChanged(AnimationStatus status) async {
    if (!mounted) return;

    if (widget.isConnected) {
      if (status != AnimationStatus.completed) return;

      await Future.delayed(
        widget.connectedDuration ?? const Duration(seconds: 2),
      );
    } else {
      if (widget.disconnectedDuration == null) return;

      await Future.delayed(
        widget.disconnectedDuration!,
      );
    }

    if (!mounted) return;

    await _controller?.reverse();

    if (!mounted) return;

    widget.hideOverlay();
  }

  @override
  void dispose() {
    _controller?.removeStatusListener(_onAnimationStatusChanged);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AnimationController? controller = _controller;
    final Animation<Offset>? tweenSlideAnimation = _tweenSlideAnimation;

    switch (widget.overlayAnimationType) {
      case OverlayAnimationType.fadeAndSlide:
        if (controller == null || tweenSlideAnimation == null) {
          return widget.child;
        }
        return FadeTransition(
          opacity: controller,
          child: SlideTransition(
            position: tweenSlideAnimation,
            child: widget.child,
          ),
        );
      case OverlayAnimationType.fade:
        if (controller == null) return widget.child;
        return FadeTransition(
          opacity: controller,
          child: widget.child,
        );
      case OverlayAnimationType.slide:
        if (tweenSlideAnimation == null) return widget.child;
        return SlideTransition(
          position: tweenSlideAnimation,
          child: widget.child,
        );
      case OverlayAnimationType.none:
        return widget.child;
    }
  }
}

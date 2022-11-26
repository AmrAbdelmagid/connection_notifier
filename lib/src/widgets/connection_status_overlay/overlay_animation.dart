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
  late final AnimationController _controller;
  late final Animation<Offset> _tweenSlideAnimation;

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

      _controller = AnimationController(
        vsync: this,
        duration: animationDuration,
        reverseDuration: animationDuration,
      )..forward();

      widget.onInitialization(_controller);

      if (widget.overlayAnimationType != OverlayAnimationType.fade) {
        _tweenSlideAnimation = Tween<Offset>(
          begin: Offset(
            0.0,
            dySlideAnimationStartingPoint,
          ),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: animationCurve,
            reverseCurve: animationCurve,
          ),
        );
      }

      _controller.addStatusListener(
        (status) async {
          if (widget.isConnected) {
            if (status == AnimationStatus.completed) {
              await Future.delayed(
                widget.connectedDuration ?? const Duration(seconds: 2),
              );
              await _controller.reverse();
              widget.hideOverlay();
            }
          } else {
            if (widget.disconnectedDuration != null) {
              await Future.delayed(
                widget.disconnectedDuration!,
              );
              await _controller.reverse();
              widget.hideOverlay();
            }
          }
        },
      );
    }
  }

  @override
  void dispose() {
    if (widget.overlayAnimationType != OverlayAnimationType.none) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.overlayAnimationType) {
      case OverlayAnimationType.fadeAndSlide:
        return FadeTransition(
          opacity: _controller,
          child: SlideTransition(
            position: _tweenSlideAnimation,
            child: widget.child,
          ),
        );
      case OverlayAnimationType.fade:
        return FadeTransition(
          opacity: _controller,
          child: widget.child,
        );
      case OverlayAnimationType.slide:
        return SlideTransition(
          position: _tweenSlideAnimation,
          child: widget.child,
        );
      case OverlayAnimationType.none:
        return widget.child;
    }
  }
}

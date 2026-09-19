import 'package:connection_notifier/connection_notifier.dart'
    show OverlayAnimationType;
import 'package:connection_notifier/src/widgets/connection_status_overlay/overlay_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// Builds an [OverlayAnimation] in isolation, the same way
  /// `ConnectionStatusView` does from inside the overlay entry.
  Widget buildOverlayAnimation({
    required bool isConnected,
    required VoidCallback hideOverlay,
    Duration? connectedDuration,
    Duration? disconnectedDuration,
    OverlayAnimationType overlayAnimationType =
        OverlayAnimationType.fadeAndSlide,
  }) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: OverlayAnimation(
        alignment: Alignment.topCenter,
        overlayAnimationType: overlayAnimationType,
        animationDuration: const Duration(milliseconds: 300),
        isConnected: isConnected,
        hideOverlay: hideOverlay,
        connectedDuration: connectedDuration,
        disconnectedDuration: disconnectedDuration,
        onInitialization: (_) {},
        child: const SizedBox(width: 100.0, height: 40.0),
      ),
    );
  }

  group('OverlayAnimation disposal during the auto-hide delay', () {
    testWidgets(
      'does not throw when disposed during the connected delay',
      (tester) async {
        bool didHideOverlay = false;

        await tester.pumpWidget(
          buildOverlayAnimation(
            isConnected: true,
            connectedDuration: const Duration(seconds: 2),
            hideOverlay: () => didHideOverlay = true,
          ),
        );

        // Let the entry animation reach `AnimationStatus.completed`, which is
        // what arms the 2 second auto-hide delay.
        await tester.pump(const Duration(milliseconds: 400));

        // The user navigates away while the delay is still pending.
        await tester.pumpWidget(const SizedBox.shrink());

        // Advance past the delay so the pending continuation runs.
        await tester.pump(const Duration(seconds: 3));

        expect(tester.takeException(), isNull);
        expect(
          didHideOverlay,
          isFalse,
          reason: 'A disposed overlay must not hide whatever replaced it.',
        );
      },
    );

    testWidgets(
      'does not throw when disposed during the disconnected delay',
      (tester) async {
        bool didHideOverlay = false;

        await tester.pumpWidget(
          buildOverlayAnimation(
            isConnected: false,
            disconnectedDuration: const Duration(seconds: 2),
            hideOverlay: () => didHideOverlay = true,
          ),
        );

        await tester.pump(const Duration(milliseconds: 400));

        await tester.pumpWidget(const SizedBox.shrink());

        await tester.pump(const Duration(seconds: 3));

        expect(tester.takeException(), isNull);
        expect(
          didHideOverlay,
          isFalse,
          reason: 'A disposed overlay must not hide whatever replaced it.',
        );
      },
    );
  });

  group('OverlayAnimation auto-hide while mounted', () {
    testWidgets(
      'hides the overlay once the connected delay elapses',
      (tester) async {
        bool didHideOverlay = false;

        await tester.pumpWidget(
          buildOverlayAnimation(
            isConnected: true,
            connectedDuration: const Duration(seconds: 2),
            hideOverlay: () => didHideOverlay = true,
          ),
        );

        await tester.pump(const Duration(milliseconds: 400));

        expect(
          didHideOverlay,
          isFalse,
          reason: 'The notification must stay up for the whole delay.',
        );

        // Delay, then the reverse animation.
        await tester.pump(const Duration(seconds: 2));
        await tester.pump(const Duration(milliseconds: 400));

        expect(didHideOverlay, isTrue);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'disposes cleanly when no ticker was ever created',
      (tester) async {
        await tester.pumpWidget(
          buildOverlayAnimation(
            isConnected: true,
            overlayAnimationType: OverlayAnimationType.none,
            connectedDuration: const Duration(seconds: 2),
            hideOverlay: () {},
          ),
        );

        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump(const Duration(seconds: 3));

        expect(tester.takeException(), isNull);
      },
    );
  });
}

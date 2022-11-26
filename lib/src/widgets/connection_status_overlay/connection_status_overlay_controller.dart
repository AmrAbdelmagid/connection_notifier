import 'package:flutter/foundation.dart' show immutable;

typedef CloseConnectionStatusOverlay = bool Function();

@immutable
class ConnectionStatusOverlayController {
  final CloseConnectionStatusOverlay close;

  const ConnectionStatusOverlayController({
    required this.close,
  });
}

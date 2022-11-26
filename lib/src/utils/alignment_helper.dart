import 'package:flutter/material.dart'
    show Alignment, AlignmentDirectional, AlignmentGeometry, immutable;

@immutable
class AlignmentHelper {
  final AlignmentGeometry alignment;

  const AlignmentHelper(this.alignment);

  bool get isTopAlignment {
    if (alignment == Alignment.topCenter ||
        alignment == Alignment.topLeft ||
        alignment == Alignment.topRight ||
        alignment == AlignmentDirectional.topCenter ||
        alignment == AlignmentDirectional.topStart ||
        alignment == AlignmentDirectional.topEnd) {
      return true;
    } else {
      return false;
    }
  }

  bool get isBottomAlignment {
    if (alignment == Alignment.bottomCenter ||
        alignment == Alignment.bottomLeft ||
        alignment == Alignment.bottomRight ||
        alignment == AlignmentDirectional.bottomCenter ||
        alignment == AlignmentDirectional.bottomStart ||
        alignment == AlignmentDirectional.bottomEnd) {
      return true;
    } else {
      return false;
    }
  }
}

import 'package:flutter/material.dart';

import '../helpers/rect_from_key.dart';

extension RectExtensions on Rect {
  Rect shiftWithOverlayState(GlobalKey<OverlayState> overlayKey) {
    final overlayRect = rectFromKey(overlayKey);
    if (overlayRect == null) return this;
    final offset = overlayRect.topLeft;
    return translate(-offset.dx, -offset.dy);
  }
}

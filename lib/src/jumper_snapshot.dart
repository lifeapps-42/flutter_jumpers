import 'package:flutter/material.dart';
import 'helpers/rect_from_key.dart';

import 'jumper_data.dart';

class JumperSnapshot {
  const JumperSnapshot._({
    required this.child,
    required this.tag,
    required this.rect,
    required this.crossFadeEnabled,
  });

  factory JumperSnapshot.fromData(JumperData data) {
    return JumperSnapshot._(
      child: data.child,
      tag: data.tag,
      rect: rectFromKey(data.key),
      crossFadeEnabled: data.crossFadeEnabled,
    );
  }

  final Widget child;
  final String tag;
  final Rect? rect;
  final bool crossFadeEnabled;
}

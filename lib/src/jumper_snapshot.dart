import 'package:flutter/material.dart';
import 'helpers/rect_from_key.dart';

import 'jumper_data.dart';

class JumperSnapshot {
  const JumperSnapshot._({
    required this.builder,
    required this.tag,
    required this.rect,
    required this.crossFadeEnabled,
  });

  factory JumperSnapshot.fromData(JumperData data) {
    return JumperSnapshot._(
      builder: data.builder,
      tag: data.tag,
      rect: rectFromKey(data.key),
      crossFadeEnabled: data.crossFadeEnabled,
    );
  }

  final Widget Function(BuildContext) builder;
  final String tag;
  final Rect? rect;
  final bool crossFadeEnabled;
}

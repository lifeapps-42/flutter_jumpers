import 'package:flutter/material.dart';

class JumperData {
  JumperData({
    required this.child,
    required this.key,
    required this.tag,
    this.isShuttle = false,
    required this.crossFadeEnabled,
  });

  final Widget child;
  final GlobalKey key;
  final String tag;
  final bool isShuttle;
  final bool crossFadeEnabled;
}

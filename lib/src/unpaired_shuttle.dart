import 'package:flutter/material.dart';

import 'extensions/rect_extensions.dart';
import 'jumper_scope_controller.dart';
import 'jumper_snapshot.dart';

class UnpairedShuttle extends StatefulWidget {
  const UnpairedShuttle({
    super.key,
    required this.controller,
    required this.jumper,
    this.isLost = false,
  });

  final JumperScopeController controller;
  final JumperSnapshot jumper;
  final bool isLost;

  @override
  State<UnpairedShuttle> createState() => _UnpairedShuttleState();
}

class _UnpairedShuttleState extends State<UnpairedShuttle> {
  static const _hightScale = 1.0;
  static const _lowScale = 0.8;
  late final Tween<double> _scaleTween;
  late final Tween<double> _opacityTween;

  @override
  void initState() {
    _scaleTween = widget.isLost
        ? Tween(begin: _hightScale, end: _lowScale)
        : Tween(begin: _lowScale, end: _hightScale);
    _opacityTween = widget.isLost
        ? Tween(begin: 1.0, end: 0.0)
        : Tween(begin: 0.0, end: 1.0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: widget.jumper.rect!
          .shiftWithOverlayState(widget.controller.overlayKey),
      child: FadeTransition(
        opacity: _opacityTween.animate(widget.controller.animation),
        child: ScaleTransition(
          scale: _scaleTween.animate(widget.controller.animation),
          child: Material(
            type: MaterialType.transparency,
            child: widget.jumper.child,
          ),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';

import 'extensions/rect_extensions.dart';
import 'jumper.dart';
import 'jumper_pair.dart';
import 'jumper_scope_controller.dart';

class AnimatedShuttle extends StatefulWidget {
  const AnimatedShuttle({
    super.key,
    required this.controller,
    required this.pair,
  });

  final JumperScopeController controller;
  final JumperPair pair;

  @override
  State<AnimatedShuttle> createState() => _AnimatedShuttleState();
}

class _AnimatedShuttleState extends State<AnimatedShuttle> {
  late final Rect? _originRect;
  late final Rect? _targetRect;
  late final RectTween _tween;
  late final Animation<Rect?> _animation;
  late Widget _shuttleBody;

  void _switchBody() {
    if (!widget.pair.crossFadeEnabled) return;
    setState(() {
      _shuttleBody = widget.pair.target.child;
    });
  }

  @override
  void initState() {
    _originRect = widget.pair.origin.rect
        ?.shiftWithOverlayState(widget.controller.overlayKey);
    _targetRect = widget.pair.target.rect
        ?.shiftWithOverlayState(widget.controller.overlayKey);
    _shuttleBody = widget.pair.origin.child;

    if (_originRect == null || _targetRect == null) {
      return super.initState();
    }

    _tween = RectTween(begin: _originRect!, end: _targetRect!);
    _animation = _tween.animate(widget.controller.animation);
    scheduleMicrotask(_switchBody);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_originRect == null || _targetRect == null) {
      return const SizedBox();
    }
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Positioned.fromRect(
          rect: _animation.value!,
          child: Material(
            type: MaterialType.transparency,
            child: Jumper.forShuttle(
              key: Key('${widget.pair.origin.tag}_shuttle'),
              controller: widget.controller,
              tag: widget.pair.origin.tag,
              crossFadeEnabled: widget.pair.crossFadeEnabled,
              child: widget.pair.crossFadeEnabled
                  ? AnimatedSwitcher(
                      duration: widget.controller.duration,
                      switchInCurve: Curves.easeOutQuint,
                      switchOutCurve: Curves.easeInExpo,
                      layoutBuilder: (child, children) {
                        return Stack(
                          fit: StackFit.expand,
                          children: [...children, child!],
                        );
                      },
                      child: Container(
                        key: Key(_shuttleBody.hashCode.toString()),
                        child: _shuttleBody,
                      ),
                    )
                  : _shuttleBody,
            ),
          ),
        );
      },
    );
  }
}

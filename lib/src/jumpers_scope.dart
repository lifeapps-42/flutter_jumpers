import 'dart:async';

import 'package:flutter/material.dart';

import 'animated_shuttle.dart';
import 'jumper_scope_controller.dart';
import 'static_shuttle.dart';
import 'unpaired_shuttle.dart';

class JumpersScope extends StatefulWidget {
  const JumpersScope({
    super.key,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.linearToEaseOut,
    this.triggerObjects = const [],
    required this.child,
  });

  final Duration duration;
  final Curve curve;
  final List<Object?> triggerObjects;
  final Widget child;

  @override
  State<JumpersScope> createState() => JumpersScopeState();
}

class JumpersScopeState extends State<JumpersScope>
    with SingleTickerProviderStateMixin {
  final _overlayKey = GlobalKey<OverlayState>();
  late final JumperScopeController controller;

  Future<void> _animate() async {
    final overlayState = _overlayKey.currentState;
    if (overlayState == null) return;

    controller.prepeareForAnimation();

    final animatedOverlays = <OverlayEntry>[];
    final unapiredOverlays = <OverlayEntry>[];
    final initialOverlays = <OverlayEntry>[];

    final jumpStartSetup = controller.getInitialJumpSetup();

    for (final jumper in jumpStartSetup.jumpers) {
      initialOverlays.add(
        OverlayEntry(
          builder: (context) => StaticShuttle(
            snapshot: jumper,
            controller: controller,
          ),
        ),
      );
    }
    overlayState.insertAll(initialOverlays);

    final jumpSetup = await controller.getJumpSetup();

    for (final jumper in jumpSetup.lost) {
      unapiredOverlays.add(
        OverlayEntry(
          builder: (context) => UnpairedShuttle(
            controller: controller,
            jumper: jumper,
            isLost: true,
          ),
        ),
      );
    }

    for (final jumper in jumpSetup.newJumpers) {
      unapiredOverlays.add(
        OverlayEntry(
          builder: (context) => UnpairedShuttle(
            controller: controller,
            jumper: jumper,
          ),
        ),
      );
    }

    for (final pair in jumpSetup.pairs) {
      animatedOverlays.add(
        OverlayEntry(
          builder: (context) =>
              AnimatedShuttle(controller: controller, pair: pair),
        ),
      );
    }
    for (final staticEntry in initialOverlays) {
      staticEntry.remove();
    }

    overlayState.insertAll(unapiredOverlays);
    overlayState.insertAll(animatedOverlays);

    // await WidgetsBinding.instance.endOfFrame;
    await controller.animate();
    for (final animatedEntry in [...animatedOverlays, ...unapiredOverlays]) {
      animatedEntry.remove();
    }
  }

  @override
  void initState() {
    controller = JumperScopeController(
      duration: widget.duration,
      curve: widget.curve,
      vsync: this,
      overlayKey: _overlayKey,
    );
    super.initState();
  }

  @override
  void didUpdateWidget(JumpersScope oldWidget) {
    bool didChangeTriggers = false;
    for (int i = 0; i < widget.triggerObjects.length; i++) {
      if (widget.triggerObjects[i] != oldWidget.triggerObjects[0]) {
        didChangeTriggers = true;
        break;
      }
    }
    if (didChangeTriggers) {
      _animate();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        JumperScopeInherited(
          controller: controller,
          child: widget.child,
        ),
        Positioned.fill(
          child: Overlay(
            key: _overlayKey,
            clipBehavior: Clip.hardEdge,
          ),
        ),
      ],
    );
  }
}

class JumperScopeInherited extends InheritedWidget {
  const JumperScopeInherited({
    super.key,
    required super.child,
    required this.controller,
  });

  final JumperScopeController controller;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

  static JumperScopeController? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<JumperScopeInherited>()
        ?.controller;
  }
}

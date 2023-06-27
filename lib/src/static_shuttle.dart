import 'package:flutter/material.dart';
import 'extensions/rect_extensions.dart';
import 'jumper_scope_controller.dart';
import 'jumper_snapshot.dart';

class StaticShuttle extends StatelessWidget {
  const StaticShuttle({
    super.key,
    required this.snapshot,
    required this.controller,
  });

  final JumperSnapshot snapshot;
  final JumperScopeController controller;

  @override
  Widget build(BuildContext context) {
    if (snapshot.rect == null) {
      return const SizedBox();
    }
    return Positioned.fromRect(
      rect: snapshot.rect!.shiftWithOverlayState(controller.overlayKey),
      child: Material(
        type: MaterialType.canvas,
        child: snapshot.child,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'jumper_data.dart';
import 'jumpers_scope.dart';

import 'jumper_scope_controller.dart';

class Jumper extends StatefulWidget {
  const Jumper({
    super.key,
    required this.tag,
    required this.builder,
    this.crossFadeEnabled = false,
  })  : controller = null,
        isShuttle = false;

  const Jumper.forShuttle({
    super.key,
    required this.tag,
    required this.builder,
    required this.controller,
    required this.crossFadeEnabled,
  }) : isShuttle = true;

  final String tag;
  final Widget Function(BuildContext context) builder;
  final JumperScopeController? controller;
  final bool isShuttle;
  final bool crossFadeEnabled;

  @override
  State<Jumper> createState() => _JumperState();
}

class _JumperState extends State<Jumper> {
  late final GlobalKey _key;
  late final JumperData _jumperData;
  var _isRegistered = false;
  late final JumperScopeController? _jumperScope;

  void _register() {
    _jumperScope = widget.controller ?? JumperScopeInherited.of(context);
    if (_jumperScope == null) return;
    _jumperData = JumperData(
      builder: widget.builder,
      key: _key,
      tag: widget.tag,
      isShuttle: widget.isShuttle,
      crossFadeEnabled: widget.crossFadeEnabled,
    );
    _jumperScope!.registerJumper(_jumperData);
    _isRegistered = true;
  }

  void _remove() {
    if (!_isRegistered) return;
    _jumperScope?.removeJumper(_jumperData);
  }

  @override
  void initState() {
    _key = GlobalKey();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_isRegistered) {
      _register();
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _jumperScope ?? const AlwaysStoppedAnimation(0.0),
      builder: (context, _) {
        final isAnimating = _jumperScope?.isAnimating ?? false;
        return Opacity(
          opacity: widget.isShuttle
              ? 1.0
              : isAnimating
                  ? 0.0
                  : 1.0,
          child: Container(
            key: _key,
            child: widget.builder(context),
          ),
        );
      },
    );
  }
}

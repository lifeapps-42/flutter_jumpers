import 'dart:async';

import 'package:flutter/material.dart';
import 'jumper_data.dart';
import 'jumper_snapshot.dart';

import 'jumper_pair.dart';
import 'jumpers_animation_set.dart';

class JumperScopeController extends ChangeNotifier {
  JumperScopeController({
    required this.duration,
    required this.curve,
    required this.vsync,
    required this.overlayKey,
  }) {
    _init();
  }

  final _jumpers = <JumperData>{};
  final _jumpersShuttles = <JumperData>{};
  var _jumpersShuttlesSnapShots = <JumperSnapshot>[];

  var _stateId = 0;
  int get stateId => _stateId;

  late final AnimationController _animationController;
  late final Animation<double> _animation;

  var _isAnimating = false;

  final Duration duration;
  final Curve curve;
  final TickerProvider vsync;
  final GlobalKey<OverlayState> overlayKey;

  bool get isAnimating => _isAnimating;
  Animation<double> get animation => _animation;
  Set<JumperData> get jumpers => {..._jumpers};
  bool _isMiddleAirTransition = false;

  void prepeareForAnimation() {
    if (isAnimating) {
      _jumpersShuttlesSnapShots = [
        ..._jumpersShuttles.map(JumperSnapshot.fromData)
      ];
      _isMiddleAirTransition = true;
      _animationController.stop(canceled: false);

      return;
    }
    _isAnimating = true;
    _isMiddleAirTransition = false;
    notifyListeners();
  }

  Future<void> animate() async {
    _stateId++;
    await _animationController.forward(from: 0.0);
    if (!_isMiddleAirTransition) {
      _isAnimating = false;
      notifyListeners();
    }
    _isMiddleAirTransition = false;
  }

  void registerJumper(JumperData data) {
    data.isShuttle ? _jumpersShuttles.add(data) : _jumpers.add(data);
  }

  void removeJumper(JumperData data) {
    data.isShuttle ? _jumpersShuttles.remove(data) : _jumpers.remove(data);
  }

  JumpStartSet getInitialJumpSetup() {
    final origins = _isMiddleAirTransition
        ? _jumpersShuttlesSnapShots
        : [..._jumpers.map(JumperSnapshot.fromData)];

    return JumpStartSet(jumpers: origins.toSet());
  }

  Future<JumpSet> getJumpSetup() async {
    final pairs = <JumperPair>{};
    final newJumpers = <JumperSnapshot>{};
    final lostJumpers = <JumperSnapshot>{};
    final origins = _isMiddleAirTransition
        ? _jumpersShuttlesSnapShots
        : [..._jumpers.map(JumperSnapshot.fromData)];

    await WidgetsBinding.instance.endOfFrame;
    final targets = [..._jumpers.map(JumperSnapshot.fromData)];

    newJumpers.addAll(targets);
    for (final origin in origins) {
      bool didFindTarget = false;
      for (final target in targets) {
        if (target.tag == origin.tag) {
          pairs.add(JumperPair(origin, target));
          didFindTarget = true;
          newJumpers.remove(target);
          break;
        }
      }
      if (!didFindTarget) {
        lostJumpers.add(origin);
      }
    }

    return JumpSet(pairs: pairs, lost: lostJumpers, newJumpers: newJumpers);
  }

  void _init() {
    _animationController =
        AnimationController(vsync: vsync, duration: duration);
    _animation = _animationController.drive(CurveTween(curve: curve));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

import 'jumper_pair.dart';
import 'jumper_snapshot.dart';

class JumpSet {
  JumpSet({
    required this.pairs,
    required this.lost,
    required this.newJumpers,
  });

  final Set<JumperPair> pairs;
  final Set<JumperSnapshot> lost;
  final Set<JumperSnapshot> newJumpers;
}

class JumpStartSet {
  JumpStartSet({
    required this.jumpers,
  });

  final Set<JumperSnapshot> jumpers;
}

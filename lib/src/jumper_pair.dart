import 'jumper_snapshot.dart';

class JumperPair {
  JumperPair(this.origin, this.target);

  final JumperSnapshot origin;
  final JumperSnapshot target;
  bool get crossFadeEnabled =>
      origin.crossFadeEnabled || target.crossFadeEnabled;
}

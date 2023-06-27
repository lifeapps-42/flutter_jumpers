import 'dart:ui';

class ColorItem {
  const ColorItem(this.color, this.number);

  final Color color;
  final int number;

  @override
  bool operator ==(Object? other) {
    if (other is! ColorItem) return false;
    return color.value == other.color.value && number == other.number;
  }

  @override
  int get hashCode => Object.hashAll([color, number]);
}

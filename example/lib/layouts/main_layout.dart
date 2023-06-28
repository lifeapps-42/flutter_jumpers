import 'package:flutter/material.dart';
import 'package:jumpers/jumpers.dart';
import '../models/color_item.dart';
import '../tile.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({
    super.key,
    required this.items,
    required this.pickCallback,
    required this.deleteCallback,
    required this.columnsCount,
  });

  final List<ColorItem> items;
  final int columnsCount;
  final void Function(ColorItem) pickCallback;
  final void Function(ColorItem) deleteCallback;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columnsCount,
        childAspectRatio: 1.0,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
      ),
      padding: const EdgeInsets.all(5.0),
      itemCount: items.length,
      primary: true,
      itemBuilder: (context, i) => Jumper(
        key: Key(items[i].number.toString()),
        tag: items[i].number.toString(),
        crossFadeEnabled: true,
        builder: (context) => Tile(
          key: Key('main_${items[i].number}'),
          item: items[i],
          pickCallback: pickCallback,
          deleteCallback: deleteCallback,
        ),
      ),
    );
  }
}

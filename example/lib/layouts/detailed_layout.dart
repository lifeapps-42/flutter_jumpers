import 'package:flutter/material.dart';
import 'package:jumpers/jumpers.dart';

import '../models/color_item.dart';
import '../tile.dart';

class DetailedLayout extends StatelessWidget {
  const DetailedLayout({
    super.key,
    required this.pickedItem,
    required this.colorItems,
    required this.pickCallback,
    required this.resetPickCallback,
  });

  final ColorItem pickedItem;
  final List<ColorItem> colorItems;
  final void Function(ColorItem) pickCallback;
  final VoidCallback resetPickCallback;

  @override
  Widget build(BuildContext context) {
    final pickList = [
      for (final item in colorItems)
        if (pickedItem.number != item.number) item
    ];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: resetPickCallback,
            child: AspectRatio(
              aspectRatio: 1.2,
              child: IgnorePointer(
                ignoring: true,
                child: Jumper(
                  key: Key(pickedItem.number.toString()),
                  tag: pickedItem.number.toString(),
                  crossFadeEnabled: true,
                  child: Tile(
                    item: pickedItem,
                    pickCallback: null,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 100.0,
          child: ListView.builder(
            itemCount: pickList.length,
            scrollDirection: Axis.horizontal,
            itemExtent: 100,
            itemBuilder: (context, i) => Padding(
              padding: const EdgeInsets.all(6.0),
              child: Jumper(
                key: Key(pickList[i].number.toString()),
                tag: pickList[i].number.toString(),
                child: Tile(
                  item: pickList[i],
                  pickCallback: pickCallback,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

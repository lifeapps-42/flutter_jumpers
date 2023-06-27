import 'package:flutter/material.dart';
import 'models/color_item.dart';

class Tile extends StatelessWidget {
  const Tile({
    super.key,
    required this.item,
    required this.pickCallback,
    this.color,
    this.deleteCallback,
  });

  final ColorItem item;
  final void Function(ColorItem)? pickCallback;
  final void Function(ColorItem)? deleteCallback;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => pickCallback?.call(item),
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: color ?? item.color,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white60,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: Text(item.number.toString())),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (deleteCallback != null)
            Positioned(
              right: 0.0,
              top: 0.0,
              child: GestureDetector(
                onTap: () => deleteCallback!.call(item),
                child: SizedBox(
                  height: 48.0,
                  width: 48.0,
                  child: Center(
                    child: Container(
                      height: 32.0,
                      width: 32.0,
                      decoration: const BoxDecoration(
                        color: Colors.white30,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close),
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
